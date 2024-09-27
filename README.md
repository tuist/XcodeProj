# XcodeProj

<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-41-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Swift Package Manager](https://img.shields.io/badge/swift%20package%20manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Release](https://img.shields.io/github/release/tuist/xcodeproj.svg)](https://github.com/tuist/xcodeproj/releases)
[![Code Coverage](https://codecov.io/gh/tuist/xcodeproj/branch/main/graph/badge.svg)](https://codecov.io/gh/tuist/xcodeproj)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/tuist/xcodeproj/blob/main/LICENSE.md)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftuist%2FXcodeProj%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/tuist/XcodeProj)

XcodeProj is a library written in Swift for parsing and working with Xcode projects. It's heavily inspired by [CocoaPods XcodeProj](https://github.com/CocoaPods/Xcodeproj) and [xcode](https://www.npmjs.com/package/xcode).

---

- [XcodeProj](#xcodeproj)
  - [Projects Using XcodeProj](#projects-using-xcodeproj)
  - [Installation](#installation)
    - [Swift Package Manager](#swift-package-manager)
    - [Scripting](#scripting)
  - [References 📚](#references-)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contributors ✨](#contributors-)

## Projects Using XcodeProj

| Project         | Repository                                                                                   |
| --------------- | -------------------------------------------------------------------------------------------- |
| ProjLint        | [github.com/JamitLabs/ProjLint](https://github.com/JamitLabs/ProjLint)                       |
| rules_xcodeproj | [github.com/buildbuddy-io/rules_xcodeproj](https://github.com/buildbuddy-io/rules_xcodeproj) |
| Rugby           | [github.com/swiftyfinch/Rugby](https://github.com/swiftyfinch/Rugby)                         |
| Sourcery        | [github.com/krzysztofzablocki/Sourcery](https://github.com/krzysztofzablocki/Sourcery)       |
| Tuist           | [github.com/tuist/tuist](https://github.com/tuist/tuist)                                     |
| XcodeGen        | [github.com/yonaskolb/XcodeGen](https://github.com/yonaskolb/XcodeGen)                       |
| xspm            | [gitlab.com/Pyroh/xspm](https://gitlab.com/Pyroh/xspm)                                       |
| Privacy Manifest| [github.com/stelabouras/privacy-manifest](https://github.com/stelabouras/privacy-manifest)   |

If you are also leveraging XcodeProj in your project, feel free to open a PR to include it in the list above.

## Installation

### Swift Package Manager

Add the dependency in your `Package.swift` file:

```swift
let package = Package(
    name: "myproject",
    dependencies: [
        .package(url: "https://github.com/tuist/XcodeProj.git", .upToNextMajor(from: "8.12.0")),
    ],
    targets: [
        .target(
            name: "myproject",
            dependencies: ["XcodeProj"]),
        ]
)
```

### Scripting

Using [`swift-sh`] you can automate project-tasks using scripts, for example we
can make a script that keeps a project’s version key in sync with the current
git tag that represents the project’s version:

```swift
#!/usr/bin/swift sh
import Foundation
import XcodeProj  // @tuist ~> 8.8.0
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
2. Open `Package.swift` with Xcode.

## License

XcodeProj is released under the MIT license. [See LICENSE](https://github.com/tuist/xcodeproj/blob/main/LICENSE.md) for details.

## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://joecolicch.io"><img src="https://avatars3.githubusercontent.com/u/2837288?v=4?s=100" width="100px;" alt="Joseph Colicchio"/><br /><sub><b>Joseph Colicchio</b></sub></a><br /><a href="#ideas-jcolicchio" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/deatondg"><img src="https://avatars0.githubusercontent.com/u/3221590?v=4?s=100" width="100px;" alt="deatondg"/><br /><sub><b>deatondg</b></sub></a><br /><a href="#ideas-deatondg" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/dflems"><img src="https://avatars3.githubusercontent.com/u/925850?v=4?s=100" width="100px;" alt="Dan Fleming"/><br /><sub><b>Dan Fleming</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=dflems" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://twitter.com/_SaschaS"><img src="https://avatars3.githubusercontent.com/u/895505?v=4?s=100" width="100px;" alt="Sascha Schwabbauer"/><br /><sub><b>Sascha Schwabbauer</b></sub></a><br /><a href="#ideas-sascha" title="Ideas, Planning, & Feedback">🤔</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/marciniwanicki"><img src="https://avatars3.githubusercontent.com/u/946649?v=4?s=100" width="100px;" alt="Marcin Iwanicki"/><br /><sub><b>Marcin Iwanicki</b></sub></a><br /><a href="#maintenance-marciniwanicki" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/adamkhazi"><img src="https://avatars2.githubusercontent.com/u/9820670?v=4?s=100" width="100px;" alt="Adam Khazi"/><br /><sub><b>Adam Khazi</b></sub></a><br /><a href="#maintenance-adamkhazi" title="Maintenance">🚧</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/elliottwilliams"><img src="https://avatars3.githubusercontent.com/u/910198?v=4?s=100" width="100px;" alt="Elliott Williams"/><br /><sub><b>Elliott Williams</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=elliottwilliams" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://muukii.app"><img src="https://avatars.githubusercontent.com/u/1888355?v=4?s=100" width="100px;" alt="Muukii"/><br /><sub><b>Muukii</b></sub></a><br /><a href="#content-muukii" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://nnsnodnb.github.io"><img src="https://avatars.githubusercontent.com/u/9856514?v=4?s=100" width="100px;" alt="Yuya Oka"/><br /><sub><b>Yuya Oka</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=nnsnodnb" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://smileykeith.com"><img src="https://avatars.githubusercontent.com/u/283886?v=4?s=100" width="100px;" alt="Keith Smiley"/><br /><sub><b>Keith Smiley</b></sub></a><br /><a href="#content-keith" title="Content">🖋</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/ileitch"><img src="https://avatars.githubusercontent.com/u/48235?v=4?s=100" width="100px;" alt="Ian Leitch"/><br /><sub><b>Ian Leitch</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=ileitch" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/subdan"><img src="https://avatars.githubusercontent.com/u/410293?v=4?s=100" width="100px;" alt="Daniil Subbotin"/><br /><sub><b>Daniil Subbotin</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=subdan" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.florentin.tech"><img src="https://avatars.githubusercontent.com/u/8288625?v=4?s=100" width="100px;" alt="Florentin Bekier"/><br /><sub><b>Florentin Bekier</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=flowbe" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/CognitiveDisson"><img src="https://avatars.githubusercontent.com/u/10621118?v=4?s=100" width="100px;" alt="Vadim Smal"/><br /><sub><b>Vadim Smal</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/issues?q=author%3ACognitiveDisson" title="Bug reports">🐛</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="http://freddi.dev"><img src="https://avatars.githubusercontent.com/u/13707872?v=4?s=100" width="100px;" alt="freddi(Yuki Aki)"/><br /><sub><b>freddi(Yuki Aki)</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=freddi-kit" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://KrisRJack.com"><img src="https://avatars.githubusercontent.com/u/35638500?v=4?s=100" width="100px;" alt="Kristopher Jackson"/><br /><sub><b>Kristopher Jackson</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=KrisRJack" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Jake-Prickett"><img src="https://avatars.githubusercontent.com/u/26095410?v=4?s=100" width="100px;" alt="Jake Prickett"/><br /><sub><b>Jake Prickett</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=Jake-Prickett" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.jakeadams.co"><img src="https://avatars.githubusercontent.com/u/3605966?v=4?s=100" width="100px;" alt="Jake Adams"/><br /><sub><b>Jake Adams</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=jakeatoms" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/mtj0928"><img src="https://avatars.githubusercontent.com/u/12427733?v=4?s=100" width="100px;" alt="matsuji"/><br /><sub><b>matsuji</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=mtj0928" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Bogdan-Belogurov"><img src="https://avatars.githubusercontent.com/u/39379705?v=4?s=100" width="100px;" alt="Bogdan Belogurov"/><br /><sub><b>Bogdan Belogurov</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=Bogdan-Belogurov" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://chuckgrindel.com/"><img src="https://avatars.githubusercontent.com/u/159968?v=4?s=100" width="100px;" alt="Chuck Grindel"/><br /><sub><b>Chuck Grindel</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=cgrindel" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://twitter.com/MonocularVision"><img src="https://avatars.githubusercontent.com/u/429790?v=4?s=100" width="100px;" alt="Michael McGuire"/><br /><sub><b>Michael McGuire</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=michaelmcguire" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/CrazyFanFan"><img src="https://avatars.githubusercontent.com/u/15794964?v=4?s=100" width="100px;" alt="C-凡"/><br /><sub><b>C-凡</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=CrazyFanFan" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.tinder.com"><img src="https://avatars.githubusercontent.com/u/566328?v=4?s=100" width="100px;" alt="Maxwell Elliott"/><br /><sub><b>Maxwell Elliott</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=maxwellE" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://brentleyjones.com"><img src="https://avatars.githubusercontent.com/u/158658?v=4?s=100" width="100px;" alt="Brentley Jones"/><br /><sub><b>Brentley Jones</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=brentleyjones" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.linkedin.com/in/tiemevanveen"><img src="https://avatars.githubusercontent.com/u/1330668?v=4?s=100" width="100px;" alt="Teameh"/><br /><sub><b>Teameh</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=teameh" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://technocidal.com"><img src="https://avatars.githubusercontent.com/u/14994778?v=4?s=100" width="100px;" alt="Johannes Ebeling"/><br /><sub><b>Johannes Ebeling</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=technocidal" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://baegteun.com"><img src="https://avatars.githubusercontent.com/u/74440939?v=4?s=100" width="100px;" alt="baegteun"/><br /><sub><b>baegteun</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=baekteun" title="Documentation">📖</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://kobachi.jp"><img src="https://avatars.githubusercontent.com/u/103150233?v=4?s=100" width="100px;" alt="Alex Kovács"/><br /><sub><b>Alex Kovács</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=AlexKobachiJP" title="Documentation">📖</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://zenangst.com"><img src="https://avatars.githubusercontent.com/u/57446?v=4?s=100" width="100px;" alt="Christoffer Winterkvist"/><br /><sub><b>Christoffer Winterkvist</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=zenangst" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="http://www.timothycosta.com"><img src="https://avatars.githubusercontent.com/u/948806?v=4?s=100" width="100px;" alt="Timothy Costa"/><br /><sub><b>Timothy Costa</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=timothycosta" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://coolmathgames.tech"><img src="https://avatars.githubusercontent.com/u/6877780?v=4?s=100" width="100px;" alt="Mary "/><br /><sub><b>Mary </b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=Mstrodl" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/Ibrahimhass"><img src="https://avatars.githubusercontent.com/u/16992520?v=4?s=100" width="100px;" alt="Md. Ibrahim Hassan"/><br /><sub><b>Md. Ibrahim Hassan</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=Ibrahimhass" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/tatagrigory"><img src="https://avatars.githubusercontent.com/u/5187973?v=4?s=100" width="100px;" alt="tatagrigory"/><br /><sub><b>tatagrigory</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=tatagrigory" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/art-divin"><img src="https://avatars.githubusercontent.com/u/1614869?v=4?s=100" width="100px;" alt="Ruslan Alikhamov"/><br /><sub><b>Ruslan Alikhamov</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=art-divin" title="Code">💻</a></td>
    </tr>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://ladislas.detoldi.me"><img src="https://avatars.githubusercontent.com/u/2206544?v=4?s=100" width="100px;" alt="Ladislas de Toldi"/><br /><sub><b>Ladislas de Toldi</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=ladislas" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://www.massicotte.org"><img src="https://avatars.githubusercontent.com/u/85322?v=4?s=100" width="100px;" alt="Matt Massicotte"/><br /><sub><b>Matt Massicotte</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=mattmassicotte" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/VorkhlikArtem"><img src="https://avatars.githubusercontent.com/u/115653999?v=4?s=100" width="100px;" alt="Артем Ворхлик"/><br /><sub><b>Артем Ворхлик</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=VorkhlikArtem" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/woin2ee"><img src="https://avatars.githubusercontent.com/u/81426024?v=4?s=100" width="100px;" alt="Jaewon-Yun"/><br /><sub><b>Jaewon-Yun</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=woin2ee" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://gera.cx"><img src="https://avatars.githubusercontent.com/u/715129?v=4?s=100" width="100px;" alt="Mike Gerasymenko"/><br /><sub><b>Mike Gerasymenko</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=mikeger" title="Code">💻</a></td>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/filipracki"><img src="https://avatars.githubusercontent.com/u/27164368?v=4?s=100" width="100px;" alt="Filip Racki"/><br /><sub><b>Filip Racki</b></sub></a><br /><a href="https://github.com/tuist/XcodeProj/commits?author=filipracki" title="Code">💻</a></td>
    </tr>
  </tbody>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!
