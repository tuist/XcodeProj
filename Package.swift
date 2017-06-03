// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "xcodeproj",
    dependencies: [
        .Package(url: "https://github.com/kylef/PathKit.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/JohnSundell/Unbox", majorVersion: 2, minor: 4),
        .Package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/tadija/AEXML", majorVersion: 4, minor: 1)
    ]
)
