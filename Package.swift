// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML.git", .exact("4.3.0")),
        .package(url: "https://github.com/apple/swift-package-manager", .revision("swift-DEVELOPMENT-SNAPSHOT-2018-09-14-a")),
    ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: ["Utility", "AEXML"]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj"]),
        .testTarget(name: "xcodeprojIntegrationTests", dependencies: ["xcodeproj"]),
    ]
)
