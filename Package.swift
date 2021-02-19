// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "w3w-swift-components-sdk",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "W3WSwiftComponentsSdk",
            targets: ["W3WSwiftComponentsSdk"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
      .package(url: "https://github.com/what3words/w3w-swift-wrapper.git", "3.6.0"..<"4.0.0"),
      .package(url: "https://github.com/what3words/w3w-swift-components.git", "2.0.0"..<"3.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "W3WSwiftComponentsSdk",
            dependencies: [
              .product(name: "W3WSwiftApi", package: "w3w-swift-wrapper"),
              .product(name: "W3WSwiftComponents", package: "w3w-swift-components")
            ]),
        .testTarget(
            name: "w3w-swift-components-sdkTests",
            dependencies: ["W3WSwiftComponentsSdk"]),
    ]
)
