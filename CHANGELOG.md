🚀 Check out the guidelines [here](https://github.com/xcodeswift/contributors/blob/master/CHANGELOG_GUIDELINES.md)

## Next version

### Added
- Add breakpoint `condition` parameter by [@alexruperez](https://github.com/alexruperez).
- Support Xcode Extension product type https://github.com/xcodeswift/xcproj/pull/190 by @briantkelley

### Fixed
- Optimised escaping of CommentedString https://github.com/xcodeswift/xcproj/pull/195 by @kastiglione
- Optimised performance of object lookups https://github.com/xcodeswift/xcproj/pull/191 by @kastiglione
- fixed PBXLegacyTarget write order https://github.com/xcodeswift/xcproj/pull/199 by @kastiglione
- fixed comment generation of PBXBuildFiles without a name https://github.com/xcodeswift/xcproj/pull/203 by @briantkelley
- fixed PBXReferenceTarget encoding in pbxproj file https://github.com/xcodeswift/xcproj/pull/202 by @briantkelley

## 1.7.0

### Added
- Support more indentation options on PBXGroups https://github.com/xcodeswift/xcproj/pull/168 by @bkase.
- Support `PBXLegacyTarget` https://github.com/xcodeswift/xcproj/pull/171 by @bkase.
- Breakpoint support through `XCBreakpointList`. https://github.com/xcodeswift/xcproj/pull/172 by [@alexruperez](https://github.com/alexruperez)
- Add convenience method to find targets with a given name https://github.com/xcodeswift/xcproj/pull/184 by @pepibumur.
- Danger plugin that fails earlier if files have been added/deleted and the Carthage project hasn't been regenerated afterwards https://github.com/xcodeswift/xcproj/pull/187 by @pepibumur.

## 1.6.1

### Fixed
- Fix encoded line breaks in PBXFileReference https://github.com/xcodeswift/xcproj/pull/177 by @yonaskolb

## 1.6.0

### Added
- PBXLegacyTarget support https://github.com/xcodeswift/xcproj/pull/171 by @bkase
- Integration tests https://github.com/xcodeswift/xcproj/pull/168 by @pepibumur
- More examples to the README https://github.com/xcodeswift/xcproj/pull/116 by @pepibumur.
- Add adding / editing command line arguments for Launch, Test and Profile Actions in `XCScheme`. https://github.com/xcodeswift/xcproj/pull/167 by @rahul-malik
- Test the contract with XcodeGen https://github.com/xcodeswift/xcproj/pull/170 by @pepibumur
- Add `PBXProj.Objects.getFileElement` https://github.com/xcodeswift/xcproj/pull/175 by @yonaskolb


### Fixed
- `PBXGroup` not generating the comment properly for its children https://github.com/xcodeswift/xcproj/pull/169 by @pepibumur.
- Make `PBXFileElement` a superclass for `PBXFileReference`, `PBXGroup`, and `PBXVariantGroup` https://github.com/xcodeswift/xcproj/pull/173 by @gubikmic
- Added `path` to `PBXVariantGroup` init https://github.com/xcodeswift/xcproj/pull/174 by @yonaskolb

## 1.5.0

### Added
- Add `codeCoverageEnabled` parameter to `TestAction` https://github.com/xcodeswift/xcproj/pull/166 by @kastiglione
- Make `final` classes that are not extendible https://github.com/xcodeswift/xcproj/pull/164 by @pepibumur.

### Fixed
- Fix `PBXProject` `productRefGroup` comment https://github.com/xcodeswift/xcproj/pull/161 by @allu22
- Fix deprecation warnings for `PBXProj` objects usage https://github.com/xcodeswift/xcproj/pull/162 by @rahul-malik

## 1.4.0 - Take me out

### Added
- Danger integration https://github.com/xcodeswift/xcproj/pull/158 by @pepibumur

### Changed
- Improve efficiency of looking up `PBXObject`'s from `PBXProj` https://github.com/xcodeswift/xcproj/pull/136 by @rahul-malik

### Deprecated
- `PBXObject` objects accessors https://github.com/xcodeswift/xcproj/pull/136/files#diff-f4369d9af58a6914f0e5cdf81ed18530R6 by @rahul-malik.

### Fixed
- Fix `PBXBuildFile` wrongly defaulting the settings attribute when it was nil https://github.com/xcodeswift/xcproj/pull/149 by @allu22
- Fix `PBXTarget` generating the wrong comment for the `productReference` property https://github.com/xcodeswift/xcproj/pull/151 by @allu22.
- Add missing `usesTabs` property to `PBXGroup` https://github.com/xcodeswift/xcproj/pull/147 by @allu22.
- Fix generated comment for `PBXHeadersBuildPhase` by @allu22.
- Fix wrong `BuidlSettings.swift` file name https://github.com/xcodeswift/xcproj/pull/146 by @allu22.
- Fix `projectReferences` type https://github.com/xcodeswift/xcproj/pull/135 by @solgar.

### Added
- Danger checks https://github.com/xcodeswift/xcproj/pull/160 by @pepibumur
- New product type `ocUnitTestBundle` https://github.com/xcodeswift/xcproj/pull/134 by @solgar.

## 1.3.0 - Esbarzers

### Added
- Add `PBXSourceTree.developerDir` type https://github.com/xcodeswift/xcproj/commit/5504fcde00bc56cf6c240ecd7cc36c05296861f8 by @pepibumur.

### Fixed
- Fix `PBXShellScriptBuildPhase` bug decoding `showEnvVarsInLog` https://github.com/xcodeswift/xcproj/commit/521b4e62b70f5fc43a06d00c43916d4899138553 by @pepibumur.
- Fix `PBXFileReference` bug decoding `useTabs` https://github.com/xcodeswift/xcproj/commit/c533987496959a3e32c0ddfe45a0f2db8d5daae0 by @pepibumur.
- Fix `PBXFileReference` bug decoding `lineEnding` https://github.com/xcodeswift/xcproj/commit/8a2c94effbe94859a68d58e0c49d66156ba1eaea by @pepibumur.


## 1.2.0 - Two shoes

### Added
- Carthage support https://github.com/xcodeswift/xcproj/pull/125 by @pepibumur.
- `buildPhases` property to `PBXProj` https://github.com/xcodeswift/xcproj/pull/132 by @pepibumur.

### Fixed
- Build phase `buildActionMask` wrong default value https://github.com/xcodeswift/xcproj/pull/131 by @pepibumur.

## 1.1.0 - Muerdo

### Added
- It supports now SPM-generated projects https://github.com/xcodeswift/xcproj/pull/124 by @pepibumur. Thanks @josefdolezal for the report.
- Project and workspace initializer that takes the path as a string https://github.com/xcodeswift/xcproj/pull/123 by @pepibumur.

### Fixed
- Fix the decoding of the `PBXFileReference.fileEncoding` property https://github.com/xcodeswift/xcproj/pull/127 by @gubikmic.
- Fix some wrong comments and typos https://github.com/xcodeswift/xcproj/pull/126 by @gubikmic

## 1.0.0 - Acho

### Changed
- **Breaking:** Review optionality of attributes to align it with Xcode one https://github.com/xcodeswift/xcproj/pull/107 by @pepibumur.
- Contributing, and code of conduct point to the organization ones by @pepibumur.
- New changelog format introduced by @pepibumur.
### Fixed
- Use the super init to decode reference in some objects https://github.com/xcodeswift/xcproj/pull/110 by @yonaskolb
- Schemes being shared with an extension https://github.com/xcodeswift/xcproj/pull/113 by @esttorhe.
- Contributors link in the README.md https://github.com/xcodeswift/xcproj/pull/117 by @tapanprakasht.

### Security

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
