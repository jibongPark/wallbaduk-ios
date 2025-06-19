import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DI",
    targets: [
        Target.target(
            name: "DI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.di",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RIBs")
            ],
            settings: .settings(base: .frameworkSettings)
        )
    ]
) 