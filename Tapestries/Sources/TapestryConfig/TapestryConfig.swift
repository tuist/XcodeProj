import PackageDescription

let config = TapestryConfig(release: Release(actions: [.pre(.dependenciesCompatibility([.cocoapods, .spm(.all)])),
                                                       .pre(tool: "tuist", arguments: ["generate"]),
                                                       .pre(tool: "bundle", arguments: ["exec", "rake", "carthage_update_dependencies"]),
                                                       .pre(tool: "bundle", arguments: ["exec", "rake", "release_check"]),
                                                       .pre(.docsUpdate),
                                                       .post(tool: "bundle", arguments: ["exec", "pod", "trunk", "push", "--allow-warnings", "--verbose"]),
                                                       .post(tool: "bundle", arguments: ["exec", "rake", "archive_carthage"])],
                                             add: ["README.md",
                                                   "xcodeproj.podspec",
                                                   "CHANGELOG.md"],
                                             commitMessage: "Version \(Argument.version)",
                                             push: true))
