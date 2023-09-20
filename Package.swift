// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pokemonApp",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "pokemonApp",
            targets: ["pokemonApp"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "pokemonApp"),
        .testTarget(
            name: "pokemonAppTests",
            dependencies: ["pokemonApp"]),
    ]
)
