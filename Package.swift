// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WallBaduk",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "GameDomain",
            targets: ["GameDomain"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/uber/RIBs", from: "0.14.1"),
        .package(url: "https://github.com/ReactiveX/RxSwift", from: "6.6.0")
    ],
    targets: [
        .target(
            name: "GameDomain",
            dependencies: [
                .product(name: "RxSwift", package: "RxSwift")
            ],
            path: "Modules/GameDomain/Sources"
        ),
        .testTarget(
            name: "GameDomainTests",
            dependencies: [
                "GameDomain",
                .product(name: "RxSwift", package: "RxSwift")
            ],
            path: "Modules/GameDomain/Tests"
        )
    ]
) 