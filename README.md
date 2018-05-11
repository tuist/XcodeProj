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

## Continuous Integration

- **Master:** [![Build Status](https://travis-ci.com/xcbuddy/xcodeproj.svg?branch=master)](https://travis-ci.com/xcbuddy/xcodeproj)
- **Integration:** [![Build Status](https://travis-ci.com/xcbuddy/xcodeproj.svg?branch=integration)](https://travis-ci.com/xcbuddy/xcodeproj)

## Contribute

1. Git clone the repository `git@github.com:xcbuddy/xcodeproj.git`.
2. Generate xcodeproj with  `swift package generate-xcodeproj`.
3. Open `xcodeproj.xcodeproj`.

## Setup

#### Using Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/xcbuddy/xcodeproj.git", .upToNextMajor(from: "5.0.0")),
        ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["xcodeproj"]),
        ]
)

```

## Documentation 📄
You can check out the documentation on the following [link](https://xcbuddy.github.io/xcodeproj/index.html). The documentation is automatically generated in every release by using [Jazzy](https://github.com/realm/jazzy) from [Realm](https://realm.io).

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
