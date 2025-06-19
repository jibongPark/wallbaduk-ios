import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GameMenu",
    targets: [
        Target.target(
            name: "GameMenu",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.gamemenu",
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
            name: "GameMenuTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.gamemenu.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GameMenu")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 