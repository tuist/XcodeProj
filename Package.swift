// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xcodeproj",
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/JohnSundell/Unbox", .upToNextMinor(from: "2.4.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .branch("swift4")),
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMinor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "xcodeprojextensions",
            dependencies: []),
        .target(
            name: "xcodeprojprotocols",
            dependencies: ["xcodeprojextensions"]),
        .target(
            name: "xcodeproj",
            dependencies: ["xcodeprojextensions", "xcodeprojprotocols"])
    ]
)
