// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tadija/AEXML", .upToNextMinor(from: "4.4.0")),
        .package(url: "https://github.com/kylef/PathKit", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/tuist/Shell", .upToNextMinor(from: "2.0.1")),
    ],
    targets: [
        .target(name: "xcodeproj",
                dependencies: [
                    "PathKit",
                    "AEXML",
                ]),
        .testTarget(name: "xcodeprojTests", dependencies: ["xcodeproj", "Shell"]),
    ]
)
