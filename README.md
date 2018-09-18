# xcodeproj

<a href="https://swift.org/package-manager">
<img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager"/>
</a>
<a href="https://github.com/tuist/xcodeproj/releases">
  <img src="https://img.shields.io/github/release/tuist/xcodeproj.svg"/>
</a>
<a href="https://opensource.org/licenses/MIT">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License" />
</a>
<a href="https://codecov.io/gh/xcodeswift/xcproj">
  <img src="https://codecov.io/gh/xcodeswift/xcproj/branch/master/graph/badge.svg" />
</a>

xcodeproj is a library written in Swift for parsing and working with Xcode projects. It's heavily inspired in [CocoaPods XcodeProj](https://github.com/CocoaPods/Xcodeproj) and [xcode](https://www.npmjs.com/package/xcode).

**This project is a fork and evolution from [xcproj](https://github.com/xcodeswift/xcproj)**

## Continuous Integration

- **Master:** [![CircleCI](https://circleci.com/gh/tuist/xcodeproj.svg?style=svg)](https://circleci.com/gh/tuist/xcodeproj)

## Contribute

1. Git clone the repository `git@github.com:tuist/xcodeproj.git`.
2. Generate xcodeproj with  `swift package generate-xcodeproj`.
3. Open `xcodeproj.xcodeproj`.

## Projects using xcodeproj

| Project | Repository             |
|---------|------------------------|
| Tuist   | [github.com/tuist/tuist](https://github.com/tuist/tuist) |
| Sourcery | [github.com/krzysztofzablocki/Sourcery](https://github.com/krzysztofzablocki/Sourcery) |
| ProjLint | [github.com/JamitLabs/ProjLint](https://github.com/JamitLabs/ProjLint) |
| XcodeGen | [github.com/yonaskolb/XcodeGen](https://github.com/yonaskolb/XcodeGen) |

If you are also leveraging xcodeproj in your project, feel free to open a PR to include it in the list above.

## Setup

#### Using Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.0.0")),
        ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["xcodeproj"]),
        ]
)
```

## Migrate to xcodeproj 6

xcodeproj 6 is the final step towards hiding the Xcode project implementation details. One of those details was the object unique identifiers, which you used to manage yourself with previous versions. Now, xcodeproj does it for you, so you don't have to pass them around to set dependencies between objects.

This improvement makes the API easier, safer and more convenient, but at the cost of introducing some breaking changes in the library. If want to migrate your project to use xcodeproj 6, these are the things that you should look at:

- `PBXObjectReference` is an internal class now. Object references to other objects are attributes with the type of the object that is being referred. For example, a `XCConfigurationList` object has an attribute `buildConfigurations` of type `XCBuildConfiguration`. Adding a new configuration is as easy as calling `list.buildConfigurations.append(config)`.
- Note that object references have different types of optionals based on the type of attribute:
  - **Implicitly unwrapped optional:** When the attribute is required by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Project/PBXProject.swift#L38)
  - **Explicitly unwrapped optional:** When the attribute is optional by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Targets/PBXTargetDependency.swift#L11)
- `PBXObjects` has also been made internal. It was exposed through the attribute `objects` on the `PBXProj` class. If you used to use this class for adding, removing, or getting objects, those methods have been moved to the `PBXProj` class - [Public helpers](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Project/PBXProj.swift#L85) 

**And yes, in case you are wondering, it fully supports Xcode 10 🎉**

## Migrate to xcodeproj 5
`xcodeproj` 5 is a major release with important changes in the API focused on making it more convenient, and simplify the references handling. This version hasn't been officially released yet but you can already start updating your project for the new version. These are the changes you'd need to make in your projects:

- `xcproj` has been renamed to `xcodeproj` so you need to update all your import statements to use the new name.
- There's no support for Carthage nor CocoaPods anymore, if you were using them for fetching `xcodeproj`, you can use the Swift Package Manager and manually setup the dependency.
- We've replaced `Path` with `AbsolutePath` and `RelativePath` from the Swift Package Manager's `Basic` framework. You might need to change some of the usages to use the new type.
- Reference attributes have been renamed to use the naming convention `attributeReference` where `attribute` is the name of the attribute. If you are interested in materializing the reference to get the object, objects provide convenient getters that you can use for that purpose. Those getters throw if the object is not found in the project.

There are some useful additions to the API that you can check out on the [CHANGELOG](https://github.com/tuist/xcodeproj/blob/master/CHANGELOG.md). 

One of those additions is an improvement on how references are managed.
 When new objects are added to the project, you get the object reference. The reference is an instance that should be used to refer that object from any other. **The value of that reference is an implementation detail that has been abstracted away from you.**

## Documentation 📄
You can check out the documentation on the following [link](https://tuist.github.io/xcodeproj/index.html). The documentation is automatically generated in every release by using [Jazzy](https://github.com/realm/jazzy) from [Realm](https://realm.io).

## References 📚

- [Xcode Project File Format](http://www.monobjc.net/xcode-project-file-format.html)
- [A brief look at the Xcode project format](http://danwright.info/blog/2010/10/xcode-pbxproject-files/)
- [pbexplorer](https://github.com/mjmsmith/pbxplorer)
- [pbxproj identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html)
- [mob-pbxproj](https://github.com/kronenthaler/mod-pbxproj)
- [Xcodeproj](https://github.com/CocoaPods/Xcodeproj)
- [Nanaimo](https://github.com/CocoaPods/Nanaimo)
- [Facebook Buck](https://buckbuild.com/javadoc/com/facebook/buck/apple/xcode/xcodeproj/package-summary.html)
- [Swift Package Manager - Xcodeproj](https://github.com/apple/swift-package-manager/tree/master/Sources/Xcodeproj)
