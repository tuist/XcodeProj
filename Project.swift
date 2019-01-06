import ProjectDescription

let project = Project(name: "xcodeproj-Carthage",
                      targets: [
                          Target(name: "xcodeproj",
                                 platform: .macOS,
                                 product: .framework,
                                 bundleId: "io.tuist.xcodeproj",
                                 infoPlist: "Info.plist",
                                 sources: "Sources/xcodeproj/**",
                                 dependencies: [
                                     .framework(path: "Carthage/Build/Mac/AEXML.framework"),
                                     .framework(path: "Carthage/Build/Mac/PathKit.framework"),
                                     .framework(path: "Carthage/Build/Mac/SwiftShell.framework"),
                          ]),
])
