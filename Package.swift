// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "xcodeproj",
    products: [
        .library(name: "xcodeproj", targets: ["xcodeproj"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/IBM-Swift/CommonCrypto", from: "0.1.4"),
        .package(url: "https://github.com/tadija/AEXML.git", from: "4.0.0"),
        .package(url: "https://github.com/johnsundell/unbox.git", from: "2.5.0")
    ],
    targets: [
        .target(
            name: "xcodeprojextensions",
            dependencies: []),
        .target(
            name: "xcodeprojprotocols",
            dependencies: ["xcodeprojextensions"]),
        .target(
            name: "xcodeproj",
            dependencies: ["xcodeprojextensions", "xcodeprojprotocols", "PathKit", "AEXML", "Unbox"]),
        .testTarget(
            name: "xcodeprojextensionsTests",
            dependencies: ["xcodeprojextensions"]),
        .testTarget(
            name: "xcodeprojTests",
            dependencies: ["xcodeproj"])
    ],
    swiftLanguageVersions: [4]
)
