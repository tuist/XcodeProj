// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-package-manager", from: "0.3.0"),
    ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: ["Utility", "AEXML"]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj"]),
        .testTarget(name: "xcodeprojIntegrationTests", dependencies: ["xcodeproj"]),
    ]
)
