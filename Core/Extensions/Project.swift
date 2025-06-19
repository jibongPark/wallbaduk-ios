import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Extensions",
    targets: [
        Target.target(
            name: "Extensions",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.extensions",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            settings: .settings(base: .frameworkSettings)
        )
    ]
) 