// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tapestries",
    products: [
    .library(name: "TapestryConfig", targets: ["TapestryConfig"])
    ],
    dependencies: [
        // Tapestry
        .package(url: "https://github.com/AckeeCZ/tapestry.git", .branch("master")),
    ],
    targets: [
        .target(name: "TapestryConfig",
                dependencies: [
                    "PackageDescription"
        ])
    ]
)