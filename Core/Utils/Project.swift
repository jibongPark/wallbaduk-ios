import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Utils",
    targets: [
        Target.target(
            name: "Utils",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.utils",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [],
            settings: .settings(base: .frameworkSettings)
        )
    ]
) 