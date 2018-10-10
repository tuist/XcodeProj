// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML", from: "4.3.3"),
        .package(url: "https://github.com/kylef/PathKit", from: "0.9.0"),
        .package(url: "https://github.com/kareman/SwiftShell", from: "4.1.2"),
    ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: [
                    "PathKit",
                    "AEXML",
                    "SwiftShell"
                ]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj"]),
        .testTarget(name: "xcodeprojIntegrationTests", dependencies: ["xcodeproj"]),
    ]
)
