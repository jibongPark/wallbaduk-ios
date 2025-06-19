import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "GameDomain",
    targets: [
        Target.target(
            name: "GameDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.game.domain",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Utils", path: "../../Core/Utils"),
                .external(name: "RxSwift")
            ],
            settings: .settings(base: .frameworkSettings)
        ),
        Target.target(
            name: "GameDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.game.domain.tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "GameDomain")
            ],
            settings: .settings(base: .testSettings)
        )
    ]
) 