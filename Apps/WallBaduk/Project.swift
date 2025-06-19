import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "WallBaduk",
    targets: [
        Target.target(
            name: "WallBaduk",
            destinations: .iOS,
            product: .app,
            bundleId: "com.wallbaduk.app",
            deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [:],
                    "CFBundleDisplayName": "벽바둑",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ]
                            ]
                        ]
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Sources/Resources/**"],
            dependencies: [
                .project(target: "DI", path: "../../Core/DI"),
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "GameDomain", path: "../../Modules/GameDomain"),
                .project(target: "GameData", path: "../../Modules/GameData"),
                .project(target: "GameMenu", path: "../../Features/GameMenu"),
                .project(target: "GameBoard", path: "../../Features/GameBoard"),
                .project(target: "GameResult", path: "../../Features/GameResult"),
                .external(name: "RIBs"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ],
            settings: .settings(
                base: .appSettings(bundleId: "com.wallbaduk.app"),
                configurations: [
                    .debug(name: "Debug", settings: .debugSettings),
                    .release(name: "Release", settings: .releaseSettings)
                ]
            )
        )
    ]
) 
