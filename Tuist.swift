import ProjectDescription

let config = Config(
    compatibleXcodeVersions: .list(["15.0", "15.1", "15.2", "16.0", "16.1", "16.2"]),
    swiftVersion: "5.9",
    generationOptions: .options(
        disablePackageVersionLocking: false
    )
) 