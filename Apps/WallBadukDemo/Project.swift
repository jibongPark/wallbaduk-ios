import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "WallBadukDemo",
    targets: [
        Target.target(
            name: "WallBadukDemo",
            destinations: .iOS,
            product: .app,
            bundleId: "com.wallbaduk.demo",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                    "CFBundleDisplayName": "벽바둑 Demo"
                ]
            ),
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "GameBoard", path: "../../Features/GameBoard"),
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .external(name: "RIBs"),
                .external(name: "RxSwift")
            ],
            settings: .settings(
                base: .appSettings(bundleId: "com.wallbaduk.demo")
            )
        )
    ]
) 
