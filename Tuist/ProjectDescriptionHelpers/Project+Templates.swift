import ProjectDescription

extension Project {
    /// 기본 프로젝트 생성 헬퍼
    public static func module(
        name: String,
        dependencies: [TargetDependency] = [],
        hasTests: Bool = false,
        testDependencies: [TargetDependency] = []
    ) -> Project {
        var targets: [Target] = [
            Target.target(
                name: name,
                destinations: .iOS,
                product: .framework,
                bundleId: "com.wallbaduk.\(name.lowercased())",
                deploymentTargets: .iOS("16.0"),
                sources: ["Sources/**"],
                dependencies: dependencies
            )
        ]
        
        if hasTests {
            let testTarget = Target.target(
                name: "\(name)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.wallbaduk.\(name.lowercased()).tests",
                deploymentTargets: .iOS("16.0"),
                sources: ["Tests/**"],
                dependencies: [.target(name: name)] + testDependencies
            )
            targets.append(testTarget)
        }
        
        return Project(
            name: name,
            targets: targets
        )
    }
} 