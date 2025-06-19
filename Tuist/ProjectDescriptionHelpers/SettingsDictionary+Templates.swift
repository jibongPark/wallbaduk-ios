import ProjectDescription

extension SettingsDictionary {
    // MARK: - Development Team Configuration
    
    /// 개발팀 ID - 모든 프로젝트에서 공통으로 사용
    private static let developmentTeam = "6FDQX23XT6"
    
    // MARK: - Base Settings
    
    /// 기본 iOS 설정 (프레임워크용)
    public static let frameworkSettings: SettingsDictionary = 
        SettingsDictionary().automaticCodeSigning(devTeam: developmentTeam).merging([
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.9",
            "SKIP_INSTALL": "YES",
            "BUILD_LIBRARY_FOR_DISTRIBUTION": "NO"
        ]) { _, new in new }
    
    /// 기본 iOS 설정 (앱용)
    public static func appSettings(bundleId: String, displayName: String? = nil) -> SettingsDictionary {
        var settings: SettingsDictionary = [
            "PRODUCT_BUNDLE_IDENTIFIER": .string(bundleId),
            "MARKETING_VERSION": "1.0.0",
            "CURRENT_PROJECT_VERSION": "1",
            "TARGETED_DEVICE_FAMILY": "1,2",
            "SUPPORTS_MACCATALYST": "NO"
        ]
        
        if let displayName = displayName {
            settings["PRODUCT_NAME"] = .string(displayName)
        }
        
        return SettingsDictionary().automaticCodeSigning(devTeam: developmentTeam).merging(settings) { _, new in new }
    }
    
    /// 기본 iOS 설정 (테스트용)
    public static let testSettings: SettingsDictionary = 
        SettingsDictionary().automaticCodeSigning(devTeam: developmentTeam).merging([
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "SWIFT_VERSION": "5.9"
        ]) { _, new in new }
    
    // MARK: - Configuration Specific Settings
    
    /// 디버그 설정
    public static let debugSettings: SettingsDictionary = [
        "SWIFT_OPTIMIZATION_LEVEL": "-Onone",
        "GCC_OPTIMIZATION_LEVEL": "0",
        "SWIFT_COMPILATION_MODE": "singlefile",
        "CODE_SIGN_IDENTITY": "iPhone Developer"
    ]
    
    /// 릴리즈 설정
    public static let releaseSettings: SettingsDictionary = [
        "SWIFT_OPTIMIZATION_LEVEL": "-O",
        "GCC_OPTIMIZATION_LEVEL": "s",
        "SWIFT_COMPILATION_MODE": "wholemodule",
        "CODE_SIGN_IDENTITY": "iPhone Distribution"
    ]
} 
