// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xcproj",
    products: [
        .library(name: "xcproj", targets: ["xcproj"]),
        ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "0.9.1")),
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMajor(from: "4.3.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
        ],
    targets: [
        .target(name: "xcproj", dependencies: ["PathKit", "AEXML"]),
        .testTarget(name: "xcprojTests", dependencies: ["xcproj"]),
        .testTarget(name: "xcprojIntegrationTests", dependencies: ["xcproj", "PathKit", "ShellOut"]),
    ]
)
