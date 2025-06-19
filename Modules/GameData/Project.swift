import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GameData",
    targets: [
        Target.target(
            name: "GameData",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.game.data",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "GameDomain", path: "../GameDomain"),
                .project(target: "Networking", path: "../../Core/Networking"),
                .external(name: "RxSwift")
            ],
            settings: .settings(base: .frameworkSettings)
        ),
        Target.target(
            name: "GameDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.game.data.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GameData"),
                .project(target: "GameDomain", path: "../GameDomain")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 