import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Networking",
    targets: [
        Target.target(
            name: "Networking",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.networking",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RxSwift")
            ],
            settings: .settings(base: .frameworkSettings)
        )
    ]
) 