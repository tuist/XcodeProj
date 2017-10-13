🚀 Check out the guidelines [here](https://github.com/xcodeswift/contributors/blob/master/CHANGELOG_GUIDELINES.md)

## 0.4.1
- Add back the `BuildSettings` typelias removed by mistake https://github.com/xcodeswift/xcproj/pull/109 by @pepibumur.
- Fix a bug decoding the `PBXProject.projectRoot` property that should be decoded as an optional https://github.com/xcodeswift/xcproj/issues/108 by @pepibumur.

## 0.4.0
- Remove dependency with Unbox and use the language coding/decoding features https://github.com/xcodeswift/xcproj/pull/99 by @pepibumur and @artemnovichkov.
- Enable xcproj in [Open Collective](https://opencollective.com/xcproj) by @pepibumur.
- Support parsing XCVersionGroup objects https://github.com/xcodeswift/xcproj/pull/96 by @pepibumur.
- Add iOS support to the `.podspec` https://github.com/xcodeswift/xcproj/pull/92 by @pepibumur.
- Fix comment for buildConfigurationList https://github.com/xcodeswift/xcproj/pull/93 by @toshi0383.
- Update `PBXProj` classes property to be a dictionary https://github.com/xcodeswift/xcproj/pull/94 by @toshi0383.
- Fix comment in the `BuildPhase` object https://github.com/xcodeswift/xcproj/pull/95 by @toshi0383.

## 0.3.0
- Turn `PBXVariantGroup` children property into an array https://github.com/xcodeswift/xcproj/pull/88 by @pepibumur
- Add `PBXReferenceProxy` object https://github.com/xcodeswift/xcproj/pull/85 by @pepibumur
- Migrate project to Swift 4 https://github.com/xcodeswift/xcproj/pull/84 by @artemnovichkov
- Fix build phase script error undoer Xcode 9 https://github.com/xcodeswift/xcproj/pull/81 by @kixswift

## 0.2.0
- Add how to use section https://github.com/xcodeswift/xcproj/pull/77 by @pepibumur
- Add contributing guidelines https://github.com/xcodeswift/xcproj/pull/76 by @pepibumur

## 0.1.2
- Update shell build script phase input and output files to be array instead of set https://github.com/xcodeswift/xcproj/issues/65 by @pepibumur
- Fix wrong comment in the shell script build phase https://github.com/xcodeswift/xcproj/issues/67 by @ppeibumur
- Fix wron gcomment in `PBXSourcesBuildPhase` files property https://github.com/xcodeswift/xcproj/issues/68 by @pepibumur
- Add `XCVersionGroup` project element used by Core Data models https://github.com/xcodeswift/xcproj/issues/69 by @pepibumur
- Update `XCConcigurationList` build configurations to be an array https://github.com/xcodeswift/xcproj/issues/70 by @pepibumur

## 0.1.1
- Change `BuildSettings` to `[String: Any]` https://github.com/xcodeswift/xcproj/pull/52 by @yonaskolb
- Plist fixes https://github.com/xcodeswift/xcproj/pull/54 by @yonaskolb

## 0.1.0
- Update struct to classes and clean up API https://github.com/xcodeswift/xcproj/pull/51 by @yonaskolb
- Fix and cleanup strings escaping https://github.com/xcodeswift/xcproj/pull/48 by @yonaskolb
- Add `runOnlyForDeploymentPostprocessing` to `PBXShellScriptBuildPhase` by @yonaskolb
- Remove force unwrap for `XCScheme` https://github.com/xcodeswift/xcproj/pull/39 by @Shakarang

## 0.0.9
- CocoaPods support https://github.com/xcodeswift/xcproj/pull/35 by @pepibumur
- Make project models mutable https://github.com/xcodeswift/xcproj/pull/33 by @yonaskolb

## 0.0.7
- Downgrade Swift Tools versions to 4.0 https://github.com/xcodeswift/xcproj/pull/27 by @yonaskolb
- Make Scheme intializers public https://github.com/xcodeswift/xcproj/pull/28 by @yonaskolb
- Change PBXGroup.children to be an array https://github.com/xcodeswift/xcproj/pull/26 by @yonaskolb
- Make XcodeProj writable https://github.com/xcodeswift/xcproj/pull/20 by @yonaskolb
- Write baseConfigurationReference https://github.com/xcodeswift/xcproj/pull/24 by @yonaskolb
- Convert booleans to YES or NO https://github.com/xcodeswift/xcproj/pull/23 by @yonaskolb
- Make more properties public https://github.com/xcodeswift/xcproj/pull/19 by @yonaskolb


## 0.0.6
- Fix an issue with unescaped strings by @yonaskolb https://github.com/xcodeswift/xcproj/issues/16
- Update Swift Tools Version to 4.0 https://github.com/xcodeswift/xcproj/commit/f0f5ffe58ce0d29bb986189abf6391c6552fd347
- Remove CryptoSwift dependency https://github.com/xcodeswift/xcproj/commit/f0f5ffe58ce0d29bb986189abf6391c6552fd347

## 0.0.5
- Remove `UUID` typealias https://github.com/xcodeswift/xcproj/pull/15
- Add `UUID` identifier generation from `PBXProj` https://github.com/xcodeswift/xcproj/pull/14

## 0.0.4
- Writing support for `PBXProj` - https://github.com/xcodeswift/xcproj/pull/8
- Document RELEASE process https://github.com/xcodeswift/xcproj/pull/7.
- Add documentation https://github.com/xcodeswift/xcproj/pull/6

## 0.0.1
- First version of the Swift library.
- It supports **reading** and parsing the following models:
    - xcodeproj.
    - xcworkspace.
    - pbxproj.
> This version doesn't support writing yet
