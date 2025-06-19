import Foundation

/// 플레이어를 나타내는 엔티티
public struct Player {
    public let id: UUID
    public let name: String
    public let color: PlayerColor
    public let pieces: [GamePiece]
    public let score: Int
    public let isAI: Bool
    public let aiDifficulty: AIDifficulty?
    
    public init(
        id: UUID = UUID(),
        name: String,
        color: PlayerColor,
        pieces: [GamePiece] = [],
        score: Int = 0,
        isAI: Bool = false,
        aiDifficulty: AIDifficulty? = nil
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.pieces = pieces
        self.score = score
        self.isAI = isAI
        self.aiDifficulty = aiDifficulty
    }
    
    /// 활성화된 말들 반환
    public var activePieces: [GamePiece] {
        return pieces.filter { $0.isActive }
    }
    
    /// 플레이어의 말 개수
    public var pieceCount: Int {
        return activePieces.count
    }
}

/// 플레이어 색상
public enum PlayerColor: String, CaseIterable {
    case black = "black"
    case white = "white"
    case blue = "blue"
    case green = "green"
    
    public var displayName: String {
        switch self {
        case .black: return "검정"
        case .white: return "흰색"
        case .blue: return "파랑"
        case .green: return "초록"
        }
    }
}

/// AI 난이도
public enum AIDifficulty: String, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    public var displayName: String {
        switch self {
        case .easy: return "쉬움"
        case .medium: return "보통"
        case .hard: return "어려움"
        }
    }
    
    public var searchDepth: Int {
        switch self {
        case .easy: return 2
        case .medium: return 4
        case .hard: return 6
        }
    }
}

// MARK: - Equatable
extension Player: Equatable {
    public static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Player: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - CustomStringConvertible
extension Player: CustomStringConvertible {
    public var description: String {
        return "Player(name: \(name), color: \(color), isAI: \(isAI))"
    }
} 