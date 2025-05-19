// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SwiftRLP",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_14),
    ],
    products: [
        .library(
            name: "SwiftRLP",
            targets: ["SwiftRLP"]
        ),
        .executable(name: "cli", targets: ["cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0")
    ],
    targets: [
        .target(name: "SwiftRLP"),
        .testTarget(
            name: "SwiftRLPTests",
            dependencies: ["SwiftRLP"]
        ),
        .executableTarget(
            name: "cli",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "SwiftRLP"),
            ]
        ),
    ]
)
