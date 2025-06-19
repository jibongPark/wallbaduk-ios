import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GameResult",
    targets: [
        Target.target(
            name: "GameResult",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.gameresult",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "GameDomain", path: "../../Modules/GameDomain"),
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Extensions", path: "../../Core/Extensions"),
                .external(name: "RIBs"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            settings: .settings(base: .frameworkSettings)
        ),
        Target.target(
            name: "GameResultTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.gameresult.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GameResult")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 