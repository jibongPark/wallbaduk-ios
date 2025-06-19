import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "WallBadukTests",
    targets: [
        Target.target(
            name: "WallBadukTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "GameDomain", path: "../../Modules/GameDomain"),
                .project(target: "GameData", path: "../../Modules/GameData"),
                .project(target: "GameBoard", path: "../../Features/GameBoard"),
                .project(target: "GameMenu", path: "../../Features/GameMenu"),
                .project(target: "GameResult", path: "../../Features/GameResult")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 