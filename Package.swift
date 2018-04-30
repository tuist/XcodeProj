// swift-tools-version:4.0

import PackageDescription
let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
        ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", .upToNextMajor(from: "0.9.1")),
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMajor(from: "4.3.0")),
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
        ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: ["PathKit", "AEXML"]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj"]),
        .testTarget(name: "xcodeprojIntegrationTests", dependencies: ["xcodeproj", "PathKit", "ShellOut"]),
    ]
)
