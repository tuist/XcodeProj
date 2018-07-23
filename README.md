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

- **Master:** [![Build Status](https://travis-ci.org/tuist/xcodeproj.svg?branch=master)](https://travis-ci.org/tuist/xcodeproj)
- **Integration:** [![Build Status](https://travis-ci.org/tuist/xcodeproj.svg?branch=integration)](https://travis-ci.org/tuist/xcodeproj)

## Contribute

1. Git clone the repository `git@github.com:tuist/xcodeproj.git`.
2. Generate xcodeproj with  `swift package generate-xcodeproj`.
3. Open `xcodeproj.xcodeproj`.

## Setup

#### Using Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "5.0.0")),
        ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["xcodeproj"]),
        ]
)
```

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
