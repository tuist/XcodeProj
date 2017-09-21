// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
        ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "0.0.8")),
        .package(url: "https://github.com/JohnSundell/Unbox.git", .upToNextMajor(from: "2.5.0")),
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMajor(from: "4.1.0")),
        ],
    targets: [
        .target(
            name: "xcodeproj",
            dependencies: ["PathKit", "Unbox", "AEXML"]),
        ]
)
