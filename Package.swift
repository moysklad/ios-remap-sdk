// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-remap-sdk",
    products: [
        .library(
            name: "MoyskladiOSRemapSDK",
            targets: ["MoyskladiOSRemapSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "4.9.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "5.0.1"),
    ],
    targets: [
        .target(
            name: "MoyskladiOSRemapSDK",
            dependencies: ["Alamofire","RxBlocking","RxCocoa","RxRelay","RxSwift"]),
    ]
)
