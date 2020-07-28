import ProjectDescription

let project = Project(name: "XcodeProj_Carthage",
                      targets: [
                          Target(name: "XcodeProj",
                                 platform: .macOS,
                                 product: .framework,
                                 bundleId: "io.tuist.XcodeProj",
                                 infoPlist: "Info.plist",
                                 sources: "Sources/XcodeProj/**",
                                 dependencies: [
                                     .framework(path: "Carthage/Build/Mac/AEXML.framework"),
                                     .framework(path: "Carthage/Build/Mac/PathKit.framework"),
                                     .framework(path: "Carthage/Build/Mac/XcodeProjCExt.framework"),
                                 ]),
                      ])
