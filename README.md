# xcodeproj

<a href="https://swift.org/package-manager">
<img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager"/>
</a>
<a href="https://github.com/xcbuddy/xcodeproj/releases">
  <img src="https://img.shields.io/github/release/xcbuddy/xcodeproj.svg"/>
</a>
<a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
</a>
<a href="https://codecov.io/gh/xcodeswift/xcproj">
  <img src="https://codecov.io/gh/xcodeswift/xcproj/branch/master/graph/badge.svg" />
</a>

xcodeproj is a library written in Swift for parsing and working with Xcode projects. It's heavily inspired in [CocoaPods XcodeProj](https://github.com/CocoaPods/Xcodeproj) and [xcode](https://www.npmjs.com/package/xcode).

**This project is a fork and evolution from [xcproj](https://github.com/xcodeswift/xcproj)**

## Continuous Integration ✅

- **Master:** [![Build Status](https://travis-ci.org/xcbuddy/xcodeproj.svg?branch=master)](https://travis-ci.org/xcbuddy/xcodeproj)
- **Integration:** [![Build Status](https://travis-ci.org/xcbuddy/xcodeproj.svg?branch=integration)](https://travis-ci.org/xcbuddy/xcodeproj)

## Motivation 💅
Being able to write command line scripts in Swift to update your Xcode projects configuration. Here you have some examples:

- Add new `Build phases`.
- Update the project `Build Settings`.
- Create new `Schemes`.

## Contribute 👨‍👩‍👧

1. Git clone the repository `git@github.com:xcbuddy/xcodeproj.git`.
2. Generate xcodeproj with  `swift package generate-xcodeproj`.
3. Open `xcodeproj.xcodeproj`.

## Setup 🦋

#### Using Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/xcbuddy/xcodeproj.git", .upToNextMajor(from: "4.2.0")),
        ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["xcodeproj"]),
        ]
)

```

#### Using [Marathon](https://github.com/JohnSundell/Marathon)

Edit your `Marathonfile` and specify the dependency in there:

```bash
https://github.com/xcbuddy/xcodeproj.git
```

#### Using [CocoaPods](https://cocoapods.org)

Edit your `Podfile` and specify the dependency:

```ruby
pod "xcodeproj"
```

#### Using [Carthage](https://github.com/carthage)

Edit your `Cartfile` and specify the dependency:

```bash
github "xcbuddy/xcodeproj"
```

> Note: xcodeproj is only available for macOS and iOS projects.

## How to use xcodeproj 🐒

Xcode provides models that represent Xcode projects and are initialized by parsing the content from your project files. The generated models are classes that can be mutated at any time. These mutations in the models are kept in memory until they are persisted by writing them back to disk by writing either the `XcodeProj` or the `XCWorkspace` model. Modifications in your projects are usually executed in three steps:

1. Read the project or workspace initializing a `XcodeProj` or a `XCWorkspace` object respectively.
2. Modify those objects or any of its dependencies.
3. Write it back to disk.

```swift
// Removing all frameworks build phases
let project = try! XcodeProj(path: "myproject.xcodeproj")
project.pbxproj.frameworksBuildPhases.removeAll()
try! project.write(path: "myproject.xcodeproj")
```

The diagram below shows the sructure of a Xcode project.

A `XcodeProj` has the following properties:
- `XCSharedData` that contains the information about the schemes of the project.
- `XCWorkspace` that defines the structure of the project workspace.
- `PBXProj` that defines the strcuture of the project.

Among other properties, the most important one in the `PBXProj` object is `Objects`. Projects are defined by a list of those objects that can be classified in the following groups:

- **Build phases objects**: Define the available build phases.
- **Target objects**: Define your project targets and dependencies between them.
- **Configuration objects**: Define the available configs and the link between them and the targets.
- **File objects**: Define the project files, build files and groups.

All objects subclass `PBXObject`, and have an unique & deterministic reference. Moreover, they are hashable and conform the `Equatable` protocol.

![diagram](Assets/diagram.png)

You can read more about what each of these objects is for on the [following link](http://www.monobjc.net/xcode-project-file-format.html)

### Considerations
- Objects references are used to define dependencies between objects. In the future we might rather use objects references instead of the unique identifier.
- The write doesn't validate the structure of the project. It's up to the developer to validate the changes that have been done using `xcodeproj`.
- New versions of Xcode might introduce new models or property that are not supported by `xcodeproj`. If you find any, don't hesitate to [open an issue](https://github.com/xcbuddy/xcodeproj/issues/new) on the repository.

## Examples

#### Reading `MyApp.xcodeproj`

```swift
let project = try XcodeProj(path: "MyApp.xcodeproj")
```

#### Writing `MyApp.xcodeproj`

```swift
try project.write(path: "MyApp.xcodeproj")
```

#### Adding `Home` group inside `Sources` group

```swift
guard var sourcesGroup = project.pbxproj.objects.groups.first(where: {$0.value.name == "Sources" || $0.value.path == "Sources"})?.value else { return }    
let homeGroup = PBXGroup(children: [], sourceTree: .group, path: "Home")
let groupRef = pbxproj.objects.generateReference(homeGroup, "Home")
sourcesGroup.children.append(homeGroup, reference: groupRef)
project.pbxproj.objects.addObject(groupRef)
```

#### Add `HomeViewController.swift` file inside `HomeGroup`

```swift
let homeViewController = PBXFileReference(sourceTree: .group, name: "HomeViewController.swift", path: "HomeViewController.swift")
let fileRef = pbxproj.objects.generateReference(homeViewController, "HomeViewController.swift")
homeGroup.children.append(fileRef)
project.pbxproj.objects.addObject(homeViewController, reference: fileRef)
```
  
#### Add `HomeViewController.swift` file to `MyApp` target

```swift
guard let sourcesBuildPhase = project.pbxproj
    .objects.nativeTargets
    .values
    .first(where: {$0.name == "MyApp"})
    .flatMap({ target -> PBXSourcesBuildPhase? in
        return project.pbxproj.objects.sourcesBuildPhases.first(where: { target.buildPhases.contains($0.key) })?.value
    }) else { return }
// PBXBuildFile is a proxy model that allows specifying some build attributes to the files
let buildFile = PBXBuildFile(fileRef: fileRef)
let buildFileRef = project.pbxproj.objects.generateReference(buildFile, "HomeViewController.swift")
project.pbxproj.objects.addObject(buildFile, reference: buildFileRef)
sourcesBuildPhase.files.append(buildFileRef)
```

## Documentation 📄
You can check out the documentation on the following [link](https://xcbuddy.github.io/xcodeproj/index.html). The documentation is automatically generated in every release by using [Jazzy](https://github.com/realm/jazzy) from [Realm](https://realm.io).

## References 📚

- [PathKit](https://github.com/kylef/PathKit)
- [Xcode Project File Format](http://www.monobjc.net/xcode-project-file-format.html)
- [A brief look at the Xcode project format](http://danwright.info/blog/2010/10/xcode-pbxproject-files/)
- [pbexplorer](https://github.com/mjmsmith/pbxplorer)
- [pbxproj identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html)
- [mob-pbxproj](https://github.com/kronenthaler/mod-pbxproj)
- [Xcodeproj](https://github.com/CocoaPods/Xcodeproj)
- [Nanaimo](https://github.com/CocoaPods/Nanaimo)
- [Facebook Buck](https://buckbuild.com/javadoc/com/facebook/buck/apple/xcode/xcodeproj/package-summary.html)
- [Swift Package Manager - Xcodeproj](https://github.com/apple/swift-package-manager/tree/master/Sources/Xcodeproj)