import ProjectDescription

extension Target {
    /// RIB 모듈 타겟 생성 헬퍼
    public static func ribModule(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: name,
            destinations: .iOS,
            product: .framework,
            bundleId: "com.wallbaduk.\(name.lowercased())",
            deploymentTargets: .iOS("16.0"),
            sources: ["Sources/**"],
            dependencies: dependencies + [
                .external(name: "RIBs"),
                .external(name: "RxSwift"),
                .external(name: "RxCocoa")
            ]
        )
    }
    
    /// 테스트 타겟 생성 헬퍼
    public static func testTarget(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Target {
        return Target.target(
            name: "\(name)Tests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.wallbaduk.\(name.lowercased()).tests",
            deploymentTargets: .iOS("16.0"),
            sources: ["Tests/**"],
            dependencies: [.target(name: name)] + dependencies
        )
    }
} 