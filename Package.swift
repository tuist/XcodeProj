// swift-tools-version:6.0.0

import PackageDescription

let package = Package(
    name: "XcodeProj",
    products: [
        .library(name: "XcodeProj", targets: ["XcodeProj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMinor(from: "4.7.0")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "1.0.1")),
    ],
    targets: [
        .target(name: "XcodeProj",
                dependencies: [
                    .product(name: "PathKit", package: "PathKit"),
                    .product(name: "AEXML", package: "AEXML"),
                ],
                swiftSettings: [
                    .enableExperimentalFeature("StrictConcurrency"),
                ]),
        .testTarget(name: "XcodeProjTests", dependencies: ["XcodeProj"]),
    ]
)
