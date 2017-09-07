## 0.1.2
- Update shell build script phase input and output files to be array instead of set https://github.com/swift-xcode/xcodeproj/issues/65 by @pepibumur
- Fix wrong comment in the shell script build phase https://github.com/swift-xcode/xcodeproj/issues/67 by @ppeibumur
- Fix wron gcomment in `PBXSourcesBuildPhase` files property https://github.com/swift-xcode/xcodeproj/issues/68 by @pepibumur
- Add `XCVersionGroup` project element used by Core Data models https://github.com/swift-xcode/xcodeproj/issues/69 by @pepibumur
- Update `XCConcigurationList` build configurations to be an array https://github.com/swift-xcode/xcodeproj/issues/70 by @pepibumur

## 0.1.1
- Change `BuildSettings` to `[String: Any]` https://github.com/carambalabs/xcodeproj/pull/52 by @yonaskolb
- Plist fixes https://github.com/carambalabs/xcodeproj/pull/54 by @yonaskolb

## 0.1.0
- Update struct to classes and clean up API https://github.com/carambalabs/xcodeproj/pull/51 by @yonaskolb
- Fix and cleanup strings escaping https://github.com/carambalabs/xcodeproj/pull/48 by @yonaskolb
- Add `runOnlyForDeploymentPostprocessing` to `PBXShellScriptBuildPhase` by @yonaskolb
- Remove force unwrap for `XCScheme` https://github.com/carambalabs/xcodeproj/pull/39 by @Shakarang

## 0.0.9
- CocoaPods support https://github.com/carambalabs/xcodeproj/pull/35 by @pepibumur
- Make project models mutable https://github.com/carambalabs/xcodeproj/pull/33 by @yonaskolb

## 0.0.7
- Downgrade Swift Tools versions to 4.0 https://github.com/carambalabs/xcodeproj/pull/27 by @yonaskolb
- Make Scheme intializers public https://github.com/carambalabs/xcodeproj/pull/28 by @yonaskolb
- Change PBXGroup.children to be an array https://github.com/carambalabs/xcodeproj/pull/26 by @yonaskolb
- Make XcodeProj writable https://github.com/carambalabs/xcodeproj/pull/20 by @yonaskolb
- Write baseConfigurationReference https://github.com/carambalabs/xcodeproj/pull/24 by @yonaskolb
- Convert booleans to YES or NO https://github.com/carambalabs/xcodeproj/pull/23 by @yonaskolb
- Make more properties public https://github.com/carambalabs/xcodeproj/pull/19 by @yonaskolb


## 0.0.6
- Fix an issue with unescaped strings by @yonaskolb https://github.com/carambalabs/xcodeproj/issues/16
- Update Swift Tools Version to 4.0 https://github.com/carambalabs/xcodeproj/commit/f0f5ffe58ce0d29bb986189abf6391c6552fd347
- Remove CryptoSwift dependency https://github.com/carambalabs/xcodeproj/commit/f0f5ffe58ce0d29bb986189abf6391c6552fd347

## 0.0.5
- Remove `UUID` typealias https://github.com/carambalabs/xcodeproj/pull/15
- Add `UUID` identifier generation from `PBXProj` https://github.com/carambalabs/xcodeproj/pull/14

## 0.0.4
- Writing support for `PBXProj` - https://github.com/carambalabs/xcodeproj/pull/8
- Document RELEASE process https://github.com/carambalabs/xcodeproj/pull/7.
- Add documentation https://github.com/carambalabs/xcodeproj/pull/6

## 0.0.1
- First version of the Swift library.
- It supports **reading** and parsing the following models:
    - xcodeproj.
    - xcworkspace.
    - pbxproj.
> This version doesn't support writing yet
