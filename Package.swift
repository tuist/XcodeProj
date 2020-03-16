// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "XcodeProj",
    products: [
        .library(name: "XcodeProj", targets: ["XcodeProj"]),
    ],
    dependencies: [
        .package(path: "../XcodeProjCExt"),
        //.package(url: "https://github.com/tuist/XcodeProjCExt", .branch("master")),
        .package(url: "https://github.com/tadija/AEXML", .upToNextMinor(from: "4.4.0")),
        .package(url: "https://github.com/kylef/PathKit", .upToNextMinor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "XcodeProj",
                dependencies: [
                    "XcodeProjCExt",
                    "PathKit",
                    "AEXML",
                ]),
        .testTarget(name: "XcodeProjTests", dependencies: ["XcodeProj"]),
    ]
)
