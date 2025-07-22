// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherPackage",
    dependencies: [
        .package(url: "https://github.com/open-meteo/sdk.git", from: "1.5.0")
    ],
    targets: [
        .target(name: "MyApp", dependencies: [
            .product(name: "OpenMeteoSdk", package: "sdk"),
        ])
    ]
)
