import RIBs

/// 전역 DI 컨테이너
public final class DIContainer {
    public static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Core Dependencies
    public lazy var logger: Logger = LoggerImpl()
    
    // MARK: - Game Dependencies  
    public var gameRepository: GameRepository?
    public var gameHistoryRepository: GameHistoryRepository?
}

// MARK: - Protocols
public protocol Logger {
    func log(_ message: String)
    func logError(_ error: Error)
}

public protocol GameRepository {}
public protocol GameHistoryRepository {}

// MARK: - Implementations
final class LoggerImpl: Logger {
    func log(_ message: String) {
        print("🎮 [WallBaduk] \(message)")
    }
    
    func logError(_ error: Error) {
        print("❌ [WallBaduk] Error: \(error)")
    }
} 