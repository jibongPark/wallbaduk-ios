import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GameBoard",
    targets: [
        Target.target(
            name: "GameBoard",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.gameboard",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "GameDomain", path: "../../Modules/GameDomain"),
                .project(target: "GameData", path: "../../Modules/GameData"),
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Extensions", path: "../../Core/Extensions"),
                .external(name: "RIBs"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            settings: .settings(base: .frameworkSettings)
        ),
        Target.target(
            name: "GameBoardTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.gameboard.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GameBoard")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 