// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "RLPSwift",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
    ],
    products: [
        .library(
            name: "RLPSwift",
            targets: ["RLPSwift"]
        ),
        .executable(name: "cli", targets: ["cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .target(name: "RLPSwift"),
        .testTarget(
            name: "RLPSwiftTests",
            dependencies: ["RLPSwift"]
        ),
        .executableTarget(
            name: "cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "RLPSwift"),
            ]
        ),
    ]
)
