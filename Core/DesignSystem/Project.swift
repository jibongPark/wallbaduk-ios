import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    targets: [
        Target.target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.designsystem",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            resources: ["Sources/Resources/**"],
            dependencies: [],
            settings: .settings(base: .frameworkSettings)
        )
    ]
) 