# xcodeproj

[![CircleCI](https://circleci.com/gh/tuist/xcodeproj.svg?style=svg)](https://circleci.com/gh/tuist/xcodeproj)
[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Release](https://img.shields.io/github/release/tuist/xcodeproj.svg)](https://github.com/tuist/xcodeproj/releases)
[![Code Coverage](https://codecov.io/gh/tuist/xcodeproj/branch/master/graph/badge.svg)](https://codecov.io/gh/tuist/xcodeproj)
[![Slack](http://slack.tuist.io/badge.svg)](http://slack.tuist.io/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/tuist/xcodeproj/blob/master/LICENSE.md)
[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/pepibumur)
<img src="https://opencollective.com/tuistapp/tiers/backer/badge.svg?label=backer&color=brightgreen" />
<img src="https://opencollective.com/tuistapp/tiers/sponsor/badge.svg?label=sponsor&color=brightgreen" />
[![Join the community on Spectrum](https://withspectrum.github.io/badge/badge.svg)](https://spectrum.chat/tuist)

xcodeproj is a library written in Swift for parsing and working with Xcode projects. It's heavily inspired in [CocoaPods XcodeProj](https://github.com/CocoaPods/Xcodeproj) and [xcode](https://www.npmjs.com/package/xcode).

**This project is a fork and evolution from [xcproj](https://github.com/xcodeswift/xcproj)**

---

- [Projects Using xcodeproj](#projects-using-xcodeproj)
- [Migration Guides](#migration-guides)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Projects Using xcodeproj

| Project | Repository             |
|---------|------------------------|
| Tuist   | [github.com/tuist/tuist](https://github.com/tuist/tuist) |
| Sourcery | [github.com/krzysztofzablocki/Sourcery](https://github.com/krzysztofzablocki/Sourcery) |
| ProjLint | [github.com/JamitLabs/ProjLint](https://github.com/JamitLabs/ProjLint) |
| XcodeGen | [github.com/yonaskolb/XcodeGen](https://github.com/yonaskolb/XcodeGen) |

If you are also leveraging xcodeproj in your project, feel free to open a PR to include it in the list above.

## Installation

### Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.5.0")),
        ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["xcodeproj"]),
        ]
)
```

### Carthage
**Only macOS**

```bash
# Cartfile
github "tuist/xcodeproj" ~> 6.5.0
```

### CocoaPods

```ruby
pod 'xcodeproj', '~> 6.5.0'
```

## Scripting

Using [`swift-sh`] you can automate project-tasks using scripts, for example we
can make a script that keeps a project’s version key in sync with the current
git tag that represents the project’s version:

```swift
#!/usr/bin/swift sh
import Foundation
import xcodeproj  // @tuist ~> 6.5
import PathKit

guard CommandLine.arguments.count == 3 else {
    let arg0 = Path(CommandLine.arguments[0]).lastComponent
    fputs("usage: \(arg0) <project> <new-version>\n", stderr)
    exit(1)
}

let projectPath = Path(CommandLine.arguments[1])
let newVersion = CommandLine.arguments[2]
let xcodeproj = try XcodeProj(path: projectPath)
let key = "CURRENT_PROJECT_VERSION"

for conf in xcodeproj.pbxproj.buildConfigurations where conf.buildSettings[key] != nil {
    conf.buildSettings[key] = newVersion
}

try xcodeproj.write(path: projectPath)
```

You could then store this in your repository, for example at
`scripts/set-project-version` and then run it:

```bash
$ scripts/set-project-version ./App.xcodeproj 1.2.3
$ git add App.xcodeproj
$ git commit -m "Bump version"
$ git tag 1.2.3
```

Future adaption could easily include determining the version and bumping it
automatically. If so, we recommend using a library that provides a `Version`
object.

[`swift-sh`]: https://github.com/mxcl/swift-sh

## Migration Guides

### xcodeproj 6

xcodeproj 6 is the final step towards hiding the Xcode project implementation details. One of those details was the object unique identifiers, which you used to manage yourself with previous versions. Now, xcodeproj does it for you, so you don't have to pass them around to set dependencies between objects.

This improvement makes the API easier, safer and more convenient, but at the cost of introducing some breaking changes in the library. If want to migrate your project to use xcodeproj 6, these are the things that you should look at:

- `PBXObjectReference` is an internal class now. Object references to other objects are attributes with the type of the object that is being referred. For example, a `XCConfigurationList` object has an attribute `buildConfigurations` of type `XCBuildConfiguration`. Adding a new configuration is as easy as calling `list.buildConfigurations.append(config)`.
- Note that object references have different types of optionals based on the type of attribute:
  - **Implicitly unwrapped optional:** When the attribute is required by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Project/PBXProject.swift#L38)
  - **Explicitly unwrapped optional:** When the attribute is optional by Xcode. [Example](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Targets/PBXTargetDependency.swift#L11)
- `PBXObjects` has also been made internal. It was exposed through the attribute `objects` on the `PBXProj` class. If you used to use this class for adding, removing, or getting objects, those methods have been moved to the `PBXProj` class - [Public helpers](https://github.com/tuist/xcodeproj/blob/master/Sources/xcodeproj/Objects/Project/PBXProj.swift#L85) 

**And yes, in case you are wondering, it fully supports Xcode 10 🎉**

### xcodeproj 5
`xcodeproj` 5 is a major release with important changes in the API focused on making it more convenient, and simplify the references handling. This version hasn't been officially released yet but you can already start updating your project for the new version. These are the changes you'd need to make in your projects:

- `xcproj` has been renamed to `xcodeproj` so you need to update all your import statements to use the new name.
- There's no support for Carthage nor CocoaPods anymore, if you were using them for fetching `xcodeproj`, you can use the Swift Package Manager and manually setup the dependency.
- We've replaced `Path` with `AbsolutePath` and `RelativePath` from the Swift Package Manager's `Basic` framework. You might need to change some of the usages to use the new type.
- Reference attributes have been renamed to use the naming convention `attributeReference` where `attribute` is the name of the attribute. If you are interested in materializing the reference to get the object, objects provide convenient getters that you can use for that purpose. Those getters throw if the object is not found in the project.

There are some useful additions to the API that you can check out on the [CHANGELOG](https://github.com/tuist/xcodeproj/blob/master/CHANGELOG.md). 

One of those additions is an improvement on how references are managed.
 When new objects are added to the project, you get the object reference. The reference is an instance that should be used to refer that object from any other. **The value of that reference is an implementation detail that has been abstracted away from you.**

## Usage 

You can check out the documentation on the following [link](https://tuist.github.io/xcodeproj/index.html). The documentation is automatically generated in every release by using [Jazzy](https://github.com/realm/jazzy) from [Realm](https://realm.io).

### References 📚

- [Xcode Project File Format](http://www.monobjc.net/xcode-project-file-format.html)
- [A brief look at the Xcode project format](http://danwright.info/blog/2010/10/xcode-pbxproject-files/)
- [pbexplorer](https://github.com/mjmsmith/pbxplorer)
- [pbxproj identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html)
- [mob-pbxproj](https://github.com/kronenthaler/mod-pbxproj)
- [Xcodeproj](https://github.com/CocoaPods/Xcodeproj)
- [Nanaimo](https://github.com/CocoaPods/Nanaimo)
- [Facebook Buck](https://buckbuild.com/javadoc/com/facebook/buck/apple/xcode/xcodeproj/package-summary.html)
- [Swift Package Manager - Xcodeproj](https://github.com/apple/swift-package-manager/tree/master/Sources/Xcodeproj)

## Contributing

1. Git clone the repository `git@github.com:tuist/xcodeproj.git`.
2. Generate xcodeproj with  `swift package generate-xcodeproj`.
3. Open `xcodeproj.xcodeproj`.

## License

xcodeproj is released under the MIT license. [See LICENSE](https://github.com/tuist/xcodeproj/blob/master/LICENSE.md) for details.


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Ftuist%2Fxcodeproj.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Ftuist%2Fxcodeproj?ref=badge_large)

## Backers

[Become a backer](https://opencollective.com/tuistapp#backer) and show your support to our open source project.

[![Tuist Backer](https://opencollective.com/tuistapp/backer/0/avatar)](https://opencollective.com/tuistapp/backer/0/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/1/avatar)](https://opencollective.com/tuistapp/backer/1/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/2/avatar)](https://opencollective.com/tuistapp/backer/2/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/3/avatar)](https://opencollective.com/tuistapp/backer/3/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/4/avatar)](https://opencollective.com/tuistapp/backer/4/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/5/avatar)](https://opencollective.com/tuistapp/backer/5/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/6/avatar)](https://opencollective.com/tuistapp/backer/6/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/7/avatar)](https://opencollective.com/tuistapp/backer/7/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/8/avatar)](https://opencollective.com/tuistapp/backer/8/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/9/avatar)](https://opencollective.com/tuistapp/backer/9/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/10/avatar)](https://opencollective.comtuistapps/backer/10/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/11/avatar)](https://opencollective.com/tuistapp/backer/11/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/12/avatar)](https://opencollective.com/tuistapp/backer/12/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/13/avatar)](https://opencollective.com/tuistapp/backer/13/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/14/avatar)](https://opencollective.com/tuistapp/backer/14/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/15/avatar)](https://opencollective.com/tuistapp/backer/15/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/16/avatar)](https://opencollective.com/tuistapp/backer/16/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/17/avatar)](https://opencollective.com/tuistapp/backer/17/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/18/avatar)](https://opencollective.com/tuistapp/backer/18/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/19/avatar)](https://opencollective.com/tuistapp/backer/19/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/20/avatar)](https://opencollective.com/tuistapp/backer/20/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/21/avatar)](https://opencollective.com/tuistapp/backer/21/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/22/avatar)](https://opencollective.com/tuistapp/backer/22/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/23/avatar)](https://opencollective.com/tuistapp/backer/23/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/24/avatar)](https://opencollective.com/tuistapp/backer/24/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/25/avatar)](https://opencollective.com/tuistapp/backer/25/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/26/avatar)](https://opencollective.com/tuistapp/backer/26/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/27/avatar)](https://opencollective.com/tuistapp/backer/27/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/28/avatar)](https://opencollective.com/tuistapp/backer/28/website)
[![Tuist Backer](https://opencollective.com/tuistapp/backer/29/avatar)](https://opencollective.com/tuistapp/backer/29/website)

## Sponsors

Does your company use Tuist?  Ask your manager or marketing team if your company would be interested in supporting our project.  Support will allow the maintainers to dedicate more time for maintenance and new features for everyone.  Also, your company's logo will show [on GitHub](https://github.com/tuist/tuist#readme) and on [our site](https://tuist.io) - who doesn't want a little extra exposure?  [Here's the info](https://opencollective.com/tuistapp)

[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/0/avatar)](https://opencollective.com/tuistapp/sponsor/0/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/1/avatar)](https://opencollective.com/tuistapp/sponsor/1/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/2/avatar)](https://opencollective.com/tuistapp/sponsor/2/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/3/avatar)](https://opencollective.com/tuistapp/sponsor/3/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/4/avatar)](https://opencollective.com/tuistapp/sponsor/4/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/5/avatar)](https://opencollective.com/tuistapp/sponsor/5/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/6/avatar)](https://opencollective.com/tuistapp/sponsor/6/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/7/avatar)](https://opencollective.com/tuistapp/sponsor/7/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/8/avatar)](https://opencollective.com/tuistapp/sponsor/8/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/9/avatar)](https://opencollective.com/tuistapp/sponsor/9/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/10/avatar)](https://opencollective.comtuistapps/sponsor/10/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/11/avatar)](https://opencollective.com/tuistapp/sponsor/11/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/12/avatar)](https://opencollective.com/tuistapp/sponsor/12/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/13/avatar)](https://opencollective.com/tuistapp/sponsor/13/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/14/avatar)](https://opencollective.com/tuistapp/sponsor/14/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/15/avatar)](https://opencollective.com/tuistapp/sponsor/15/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/16/avatar)](https://opencollective.com/tuistapp/sponsor/16/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/17/avatar)](https://opencollective.com/tuistapp/sponsor/17/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/18/avatar)](https://opencollective.com/tuistapp/sponsor/18/website)
[![Tuist Backer](https://opencollective.com/tuistapp/sponsor/19/avatar)](https://opencollective.com/tuistapp/sponsor/19/website)


## Open source

Tuist is a proud supporter of the [Software Freedom Conservacy](https://sfconservancy.org/)

<a href="https://sfconservancy.org/supporter/"><img src="https://sfconservancy.org/img/supporter-badge.png" width="194" height="90" alt="Become a Conservancy Supporter!" border="0"/></a>
