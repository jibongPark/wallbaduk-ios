import ProjectDescription

let project = Project(
    name: "WallBaduk",
    organizationName: "WallBaduk",
    settings: .settings(
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    targets: []
) 