import ProjectDescription

let workspace = Workspace(
    name: "WallBaduk",
    projects: [
        ".",
        "Apps/WallBaduk",
        "Apps/WallBadukDemo", 
        "Apps/WallBadukTests",
        "Core/DI",
        "Core/Extensions",
        "Core/DesignSystem",
        "Core/Networking",
        "Core/Utils",
        "Modules/GameDomain",
        "Modules/GameData",
        "Features/GameBoard",
        "Features/GameMenu",
        "Features/GameResult"
    ]
) 