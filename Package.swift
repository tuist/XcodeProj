// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "xcodeproj",
    targets: [
        Target(
            name: "xcodeprojextensions",
            dependencies: []),
        Target(
            name: "xcodeprojprotocols",
            dependencies: ["xcodeprojextensions"]),
        Target(
            name: "xcodeproj",
            dependencies: ["xcodeprojextensions", "xcodeprojprotocols"])
    ],
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/JohnSundell/Unbox", majorVersion: 2, minor: 5),
        .Package(url: "https://github.com/tadija/AEXML.git", majorVersion: 4, minor: 1)
    ]
)
