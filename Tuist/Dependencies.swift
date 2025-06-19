import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(
                url: "https://github.com/uber/RIBs",
                requirement: .upToNextMajor(from: "0.14.1")
            ),
            .remote(
                url: "https://github.com/ReactiveX/RxSwift",
                requirement: .upToNextMajor(from: "6.6.0")
            )
        ]
    ),
    platforms: [.iOS]
) 