import Foundation

/// 게임 설정을 나타내는 엔티티
public struct GameSettings {
    public let boardSize: BoardSize
    public let playerCount: Int
    public let timeLimit: TimeLimit
    public let aiDifficulty: AIDifficulty?
    public let colorTheme: ColorTheme
    public let isOnlineMode: Bool
    public let allowSpectators: Bool
    
    public init(
        boardSize: BoardSize = .small,
        playerCount: Int = 2,
        timeLimit: TimeLimit = .medium,
        aiDifficulty: AIDifficulty? = nil,
        colorTheme: ColorTheme = .traditional,
        isOnlineMode: Bool = false,
        allowSpectators: Bool = false
    ) {
        self.boardSize = boardSize
        self.playerCount = playerCount
        self.timeLimit = timeLimit
        self.aiDifficulty = aiDifficulty
        self.colorTheme = colorTheme
        self.isOnlineMode = isOnlineMode
        self.allowSpectators = allowSpectators
    }
    
    /// 유효한 설정인지 확인
    public var isValid: Bool {
        return playerCount >= 2 && playerCount <= 4
    }
    
    /// AI 게임인지 확인
    public var isAIGame: Bool {
        return aiDifficulty != nil
    }
}

/// 게임 제한 시간
public enum TimeLimit: Int, CaseIterable {
    case short = 30     // 30초
    case medium = 60    // 1분
    case long = 90      // 1분 30초
    case unlimited = 0  // 무제한
    
    public var displayName: String {
        switch self {
        case .short: return "30초"
        case .medium: return "1분"
        case .long: return "1분 30초"
        case .unlimited: return "무제한"
        }
    }
    
    public var seconds: Int {
        return rawValue
    }
    
    public var isUnlimited: Bool {
        return self == .unlimited
    }
}

/// 색상 테마
public enum ColorTheme: String, CaseIterable {
    case traditional = "traditional"
    case modern = "modern"
    case dark = "dark"
    
    public var displayName: String {
        switch self {
        case .traditional: return "전통"
        case .modern: return "모던"
        case .dark: return "다크"
        }
    }
}

// MARK: - Equatable
extension GameSettings: Equatable {
    public static func == (lhs: GameSettings, rhs: GameSettings) -> Bool {
        return lhs.boardSize == rhs.boardSize &&
               lhs.playerCount == rhs.playerCount &&
               lhs.timeLimit == rhs.timeLimit &&
               lhs.aiDifficulty == rhs.aiDifficulty &&
               lhs.colorTheme == rhs.colorTheme &&
               lhs.isOnlineMode == rhs.isOnlineMode &&
               lhs.allowSpectators == rhs.allowSpectators
    }
}

// MARK: - CustomStringConvertible
extension GameSettings: CustomStringConvertible {
    public var description: String {
        return "GameSettings(boardSize: \(boardSize), playerCount: \(playerCount), timeLimit: \(timeLimit))"
    }
} 