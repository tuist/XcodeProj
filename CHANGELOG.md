# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.27.7] - 2025-03-14
### Details
#### Chore
- Update dependency tadija/aexml to from: "4.7.0" by @renovate[bot] in [#912](https://github.com/tuist/XcodeProj/pull/912)

## [8.27.6] - 2025-03-14
### Details
#### Miscellaneous Tasks
- Update changelog and renovate configuration by @pepicrft in [#911](https://github.com/tuist/XcodeProj/pull/911)

## [8.27.0] - 2025-02-18
### Details
#### Features
- Support `PBXFileSystemSynchronizedGroupBuildPhaseMembershipExceptionSet` by @adincebic in [#894](https://github.com/tuist/XcodeProj/pull/894)

## New Contributors
* @adincebic made their first contribution in [#894](https://github.com/tuist/XcodeProj/pull/894)
## [8.26.8] - 2025-02-18
### Details
#### Refactor
- Strongly type plist values to achieve full sendability by @waltflanagan in [#904](https://github.com/tuist/XcodeProj/pull/904)

## [8.26.5] - 2025-01-27
### Details
#### Bug Fixes
- Ensure that file references are fixed for filesystem synchronized root groups by @bryansum in [#897](https://github.com/tuist/XcodeProj/pull/897)

## New Contributors
* @bryansum made their first contribution in [#897](https://github.com/tuist/XcodeProj/pull/897)
## [8.26.4] - 2025-01-24
### Details
#### Bug Fixes
- Add missing BuildSettingsProvider for visionOS by @alexanderwe in [#898](https://github.com/tuist/XcodeProj/pull/898)

## New Contributors
* @alexanderwe made their first contribution in [#898](https://github.com/tuist/XcodeProj/pull/898)
## [8.26.0] - 2024-12-21
### Details
#### Features
- Add path to XcodeProj and XCWorkspace by @ajkolean in [#892](https://github.com/tuist/XcodeProj/pull/892)

## New Contributors
* @ajkolean made their first contribution in [#892](https://github.com/tuist/XcodeProj/pull/892)
## [8.25.1] - 2024-12-19
### Details
#### Bug Fixes
- Infinite recursion and Incorrect deprecation notice in PathRunnable by @georgenavarro in [#889](https://github.com/tuist/XcodeProj/pull/889)

## [8.25.0] - 2024-12-03
### Details
#### Features
- Add handling for Swift Testing Only Parallelization by @kelvinharron in [#871](https://github.com/tuist/XcodeProj/pull/871)

## New Contributors
* @kelvinharron made their first contribution in [#871](https://github.com/tuist/XcodeProj/pull/871)
## [8.24.13] - 2024-12-03
### Details
#### Documentation
- Add Speakus as a contributor for code by @allcontributors[bot] in [#887](https://github.com/tuist/XcodeProj/pull/887)

#### Refactor
- Update PathRunnable so that it subclasses Runnable by @georgenavarro in [#883](https://github.com/tuist/XcodeProj/pull/883)

## [8.24.12] - 2024-12-03
### Details
#### Bug Fixes
- Inconsistent behaviour with Xcode 16 when `PBXProject.TargetAttributes` is empty by @Speakus in [#865](https://github.com/tuist/XcodeProj/pull/865)

#### Documentation
- Add kelvinharron as a contributor for code by @allcontributors[bot] in [#886](https://github.com/tuist/XcodeProj/pull/886)
- Add georgenavarro as a contributor for code by @allcontributors[bot] in [#885](https://github.com/tuist/XcodeProj/pull/885)

## New Contributors
* @Speakus made their first contribution in [#865](https://github.com/tuist/XcodeProj/pull/865)
## [8.24.10] - 2024-11-20
### Details
#### Refactor
- Align ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES with the Xcode default by @yungu0010 in [#881](https://github.com/tuist/XcodeProj/pull/881)

## New Contributors
* @yungu0010 made their first contribution in [#881](https://github.com/tuist/XcodeProj/pull/881)
## [8.24.2] - 2024-10-10
### Details
#### Bug Fixes
- Issues parsing Xcode 16 projects by @pepicrft in [#862](https://github.com/tuist/XcodeProj/pull/862)

## [8.24.1] - 2024-09-27
### Details
#### Bug Fixes
- Repository cleanup by @pepicrft in [#859](https://github.com/tuist/XcodeProj/pull/859)

## [8.24.0] - 2024-09-27
### Details
#### Features
- Make `PBXProject.compatibilityVersion` optional and add `PBXProject.preferredProjectObjectVersion` to support Xcode 16 by @kimdv in [#854](https://github.com/tuist/XcodeProj/pull/854)

## [8.23.9] - 2024-09-27
### Details
#### Bug Fixes
- Order for `XCLocalSwiftPackageReference` and `XCRemoteSwiftPackageReference` by @kimdv in [#855](https://github.com/tuist/XcodeProj/pull/855)

## [8.23.8] - 2024-09-26
### Details
#### Bug Fixes
- Error: ambiguous use of 'arc4random_uniform' on Linux distros by @Howler4695 in [#846](https://github.com/tuist/XcodeProj/pull/846)

## New Contributors
* @Howler4695 made their first contribution in [#846](https://github.com/tuist/XcodeProj/pull/846)
## [8.23.0] - 2024-08-11
### Details
#### Documentation
- Add filipracki as a contributor for code by @allcontributors[bot] in [#832](https://github.com/tuist/XcodeProj/pull/832)

#### Features
- Introduce the new Xcode 16 models `PBXFileSystemSynchronizedRootGroup` and `PBXFileSystemSynchronizedBuildFileExceptionSet` by @pepicrft in [#827](https://github.com/tuist/XcodeProj/pull/827)

#### Miscellaneous Tasks
- Continuously release releasable changes by @pepicrft in [#842](https://github.com/tuist/XcodeProj/pull/842)
- Disable the renovatebot dashboard by @pepicrft in [#840](https://github.com/tuist/XcodeProj/pull/840)
- Set up SwiftLint and SwiftFormat, run them against the project, and run them as part of the CI workflows by @pepicrft in [#836](https://github.com/tuist/XcodeProj/pull/836)

[8.27.7]: https://github.com/tuist/XcodeProj/compare/8.27.6..8.27.7
[8.27.6]: https://github.com/tuist/XcodeProj/compare/8.27.5..8.27.6
[8.27.0]: https://github.com/tuist/XcodeProj/compare/8.26.8..8.27.0
[8.26.8]: https://github.com/tuist/XcodeProj/compare/8.26.7..8.26.8
[8.26.5]: https://github.com/tuist/XcodeProj/compare/8.26.4..8.26.5
[8.26.4]: https://github.com/tuist/XcodeProj/compare/8.26.3..8.26.4
[8.26.0]: https://github.com/tuist/XcodeProj/compare/8.25.1..8.26.0
[8.25.1]: https://github.com/tuist/XcodeProj/compare/8.25.0..8.25.1
[8.25.0]: https://github.com/tuist/XcodeProj/compare/8.24.13..8.25.0
[8.24.13]: https://github.com/tuist/XcodeProj/compare/8.24.12..8.24.13
[8.24.12]: https://github.com/tuist/XcodeProj/compare/8.24.11..8.24.12
[8.24.10]: https://github.com/tuist/XcodeProj/compare/8.24.9..8.24.10
[8.24.2]: https://github.com/tuist/XcodeProj/compare/8.24.1..8.24.2
[8.24.1]: https://github.com/tuist/XcodeProj/compare/8.24.0..8.24.1
[8.24.0]: https://github.com/tuist/XcodeProj/compare/8.23.11..8.24.0
[8.23.9]: https://github.com/tuist/XcodeProj/compare/8.23.8..8.23.9
[8.23.8]: https://github.com/tuist/XcodeProj/compare/8.23.7..8.23.8
[8.23.0]: https://github.com/tuist/XcodeProj/compare/8.22.0..8.23.0


Check out [GitHub releases](https://github.com/tuist/XcodeProj/releases) for older releases.

<!-- generated by git-cliff -->
