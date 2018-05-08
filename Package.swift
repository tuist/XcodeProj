// swift-tools-version:4.0

import PackageDescription
let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMajor(from: "4.3.0")),
        .package(url: "https://github.com/apple/swift-package-manager", .upToNextMajor(from: "0.2.0")),
    ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: ["Utility", "AEXML"]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj"]),
        .testTarget(name: "xcodeprojIntegrationTests", dependencies: ["xcodeproj"]),
    ]
)
