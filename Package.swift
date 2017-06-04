// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "xcodeproj",
    swiftLanguageVersions: [3],
    targets: [
        Target(
            name: "Extensions",
            dependencies: []),
        Target(
            name: "Protocols",
            dependencies: ["Extensions"]),
        Target(
            name: "Models",
            dependencies: ["Extensions", "Protocols"])
    ],
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/JohnSundell/Unbox", majorVersion: 2, minor: 4),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/drmohundro/SWXMLHash", majorVersion: 4, minor: 1)
    ]
)
