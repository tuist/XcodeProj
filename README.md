# XcodeProj

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-16-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Release](https://img.shields.io/github/release/tuist/xcodeproj.svg)](https://github.com/tuist/xcodeproj/releases)
[![Code Coverage](https://codecov.io/gh/tuist/xcodeproj/branch/main/graph/badge.svg)](https://codecov.io/gh/tuist/xcodeproj)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/tuist/xcodeproj/blob/main/LICENSE.md)

XcodeProj is a library written in Swift for parsing and working with Xcode projects. It's heavily inspired by [CocoaPods XcodeProj](https://github.com/CocoaPods/Xcodeproj) and [xcode](https://www.npmjs.com/package/xcode).

---

- [XcodeProj](#xcodeproj)
  - [Projects Using XcodeProj](#projects-using-xcodeproj)
  - [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Carthage](#carthage)
    - [CocoaPods](#cocoapods)
    - [Scripting](#scripting)
  - [Documentation 📝](#documentation-)
  - [References 📚](#references-)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contributors ✨](#contributors-)

## Projects Using XcodeProj

| Project  | Repository                                                                             |
| -------- | -------------------------------------------------------------------------------------- |
| Tuist    | [github.com/tuist/tuist](https://github.com/tuist/tuist)                               |
| Sourcery | [github.com/krzysztofzablocki/Sourcery](https://github.com/krzysztofzablocki/Sourcery) |
| ProjLint | [github.com/JamitLabs/ProjLint](https://github.com/JamitLabs/ProjLint)                 |
| XcodeGen | [github.com/yonaskolb/XcodeGen](https://github.com/yonaskolb/XcodeGen)                 |
| xspm     | [gitlab.com/Pyroh/xspm](https://gitlab.com/Pyroh/xspm)                                 |

If you are also leveraging XcodeProj in your project, feel free to open a PR to include it in the list above.

## Installation

### Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.6.0")),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["XcodeProj"]),
        ]
)
```

### Carthage

**Only macOS**

```bash
# Cartfile
github "tuist/xcodeproj" ~> 8.6.0
```

### CocoaPods

```ruby
pod 'xcodeproj', '~> 8.6.0
```

### Scripting

Using [`swift-sh`] you can automate project-tasks using scripts, for example we
can make a script that keeps a project’s version key in sync with the current
git tag that represents the project’s version:

```swift
#!/usr/bin/swift sh
import Foundation
import XcodeProj  // @tuist ~> 8.6.0
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

## Documentation 📝

Want to start using XcodeProj? Start by digging into our [documentation](/Documentation) which will help you get familiar with the API and get to know more about the Xcode projects structure.

## References 📚

- [Xcode Project File Format](http://www.monobjc.net/xcode-project-file-format.html)
- [A brief look at the Xcode project format](http://danwright.info/blog/2010/10/xcode-pbxproject-files/)
- [pbexplorer](https://github.com/mjmsmith/pbxplorer)
- [pbxproj identifiers](https://pewpewthespells.com/blog/pbxproj_identifiers.html)
- [mob-pbxproj](https://github.com/kronenthaler/mod-pbxproj)
- [Xcodeproj](https://github.com/CocoaPods/Xcodeproj)
- [Nanaimo](https://github.com/CocoaPods/Nanaimo)
- [Facebook Buck](https://buckbuild.com/javadoc/com/facebook/buck/apple/xcode/xcodeproj/package-summary.html)
- [Swift Package Manager - Xcodeproj](https://github.com/apple/swift-package-manager/tree/main/Sources/Xcodeproj)

## Contributing

1. Git clone the repository `git@github.com:tuist/xcodeproj.git`.
2. Generate xcodeproj with `swift package generate-xcodeproj`.
3. Open `XcodeProj.xcodeproj`.

## License

XcodeProj is released under the MIT license. [See LICENSE](https://github.com/tuist/xcodeproj/blob/main/LICENSE.md) for details.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://joecolicch.io"><img src="https://avatars3.githubusercontent.com/u/2837288?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Joseph Colicchio</b></sub></a><br /><a href="#ideas-jcolicchio" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/deatondg"><img src="https://avatars0.githubusercontent.com/u/3221590?v=4?s=100" width="100px;" alt=""/><br /><sub><b>deatondg</b></sub></a><br /><a href="#ideas-deatondg" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/dflems"><img src="https://avatars3.githubusercontent.com/u/925850?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Dan Fleming</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=dflems" title="Code">💻</a></td>
    <td align="center"><a href="https://twitter.com/_SaschaS"><img src="https://avatars3.githubusercontent.com/u/895505?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Sascha Schwabbauer</b></sub></a><br /><a href="#ideas-sascha" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/marciniwanicki"><img src="https://avatars3.githubusercontent.com/u/946649?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marcin Iwanicki</b></sub></a><br /><a href="#maintenance-marciniwanicki" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/adamkhazi"><img src="https://avatars2.githubusercontent.com/u/9820670?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Adam Khazi</b></sub></a><br /><a href="#maintenance-adamkhazi" title="Maintenance">🚧</a></td>
    <td align="center"><a href="https://github.com/elliottwilliams"><img src="https://avatars3.githubusercontent.com/u/910198?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Elliott Williams</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=elliottwilliams" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://muukii.app"><img src="https://avatars.githubusercontent.com/u/1888355?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Muukii</b></sub></a><br /><a href="#content-muukii" title="Content">🖋</a></td>
    <td align="center"><a href="https://nnsnodnb.github.io"><img src="https://avatars.githubusercontent.com/u/9856514?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Yuya Oka</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=nnsnodnb" title="Code">💻</a></td>
    <td align="center"><a href="https://smileykeith.com"><img src="https://avatars.githubusercontent.com/u/283886?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Keith Smiley</b></sub></a><br /><a href="#content-keith" title="Content">🖋</a></td>
    <td align="center"><a href="https://github.com/ileitch"><img src="https://avatars.githubusercontent.com/u/48235?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ian Leitch</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=ileitch" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/subdan"><img src="https://avatars.githubusercontent.com/u/410293?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Daniil Subbotin</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=subdan" title="Code">💻</a></td>
    <td align="center"><a href="https://www.florentin.tech"><img src="https://avatars.githubusercontent.com/u/8288625?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Florentin Bekier</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=flowbe" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/CognitiveDisson"><img src="https://avatars.githubusercontent.com/u/10621118?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Vadim Smal</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/issues?q=author%3ACognitiveDisson" title="Bug reports">🐛</a></td>
  </tr>
  <tr>
    <td align="center"><a href="http://freddi.dev"><img src="https://avatars.githubusercontent.com/u/13707872?v=4?s=100" width="100px;" alt=""/><br /><sub><b>freddi(Yuki Aki)</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=freddi-kit" title="Code">💻</a></td>
    <td align="center"><a href="http://KrisRJack.com"><img src="https://avatars.githubusercontent.com/u/35638500?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Kristopher Jackson</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=KrisRJack" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
