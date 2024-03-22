// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "XcodeProj",
    products: [
        .library(name: "XcodeProj", targets: ["XcodeProj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMinor(from: "4.6.1")),
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "1.0.1")),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0")
    ],
    targets: [
        .target(name: "XcodeProj",
                dependencies: [
                    .product(name: "PathKit", package: "pathkit"),
                    .product(name: "AEXML", package: "aexml")
                ]),
        .testTarget(name: "XcodeProjTests", dependencies: ["XcodeProj"]),
    ]
)
