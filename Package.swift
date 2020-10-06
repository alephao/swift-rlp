// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "RLPSwift",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "RLPSwift",
            targets: ["RLPSwift"]
        ),
    ],
    targets: [
        .target(name: "RLPSwift"),
        .testTarget(
            name: "RLPSwiftTests",
            dependencies: ["RLPSwift"]
        ),
    ]
)
