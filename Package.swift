// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "RLPSwift",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "RLPSwift",
            targets: ["RLPSwift"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RLPSwift",
        dependencies: [],
        path: "Source"),
        .testTarget(
        name: "RLPSwiftTests",
        dependencies: ["RLPSwift"],
        path: "Tests")
    ]
)
