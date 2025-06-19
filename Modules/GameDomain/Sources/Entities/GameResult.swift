import Foundation

/// 게임 결과를 나타내는 엔티티
public struct GameResult {
    public let gameID: UUID
    public let winnerID: UUID?
    public let playerScores: [UUID: Int]
    public let gameStats: GameStats
    public let endReason: GameEndReason
    public let finishedAt: Date
    
    public init(
        gameID: UUID,
        winnerID: UUID? = nil,
        playerScores: [UUID: Int],
        gameStats: GameStats,
        endReason: GameEndReason,
        finishedAt: Date = Date()
    ) {
        self.gameID = gameID
        self.winnerID = winnerID
        self.playerScores = playerScores
        self.gameStats = gameStats
        self.endReason = endReason
        self.finishedAt = finishedAt
    }
    
    /// 승자 결정
    public func determineWinner() -> UUID? {
        guard let maxScore = playerScores.values.max() else { return nil }
        
        let winnersWithMaxScore = playerScores.filter { $0.value == maxScore }
        
        // 동점자가 1명인 경우
        if winnersWithMaxScore.count == 1 {
            return winnersWithMaxScore.first?.key
        }
        
        // 동점 처리 로직 (추후 구현)
        return nil
    }
    
    /// 게임이 무승부인지 확인
    public var isDraw: Bool {
        return winnerID == nil && endReason == .draw
    }
    
    /// 게임 순위 반환
    public var playerRankings: [(UUID, Int)] {
        return playerScores.sorted { $0.value > $1.value }
    }
}

/// 게임 통계
public struct GameStats {
    public let totalTurns: Int
    public let totalMoves: Int
    public let totalWallsPlaced: Int
    public let gameDuration: TimeInterval
    public let averageThinkingTime: TimeInterval
    
    public init(
        totalTurns: Int,
        totalMoves: Int,
        totalWallsPlaced: Int,
        gameDuration: TimeInterval,
        averageThinkingTime: TimeInterval
    ) {
        self.totalTurns = totalTurns
        self.totalMoves = totalMoves
        self.totalWallsPlaced = totalWallsPlaced
        self.gameDuration = gameDuration
        self.averageThinkingTime = averageThinkingTime
    }
    
    /// 게임 시간 포맷 (mm:ss)
    public var formattedGameDuration: String {
        let minutes = Int(gameDuration) / 60
        let seconds = Int(gameDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

/// 게임 종료 이유
public enum GameEndReason: String, CaseIterable {
    case territoryCalculation = "territory_calculation"  // 영역 계산에 의한 종료
    case isolation = "isolation"                        // 모든 말이 격리됨
    case noMovesAvailable = "no_moves_available"        // 더 이상 이동 불가
    case maxTurnsReached = "max_turns_reached"          // 최대 턴 수 도달
    case playerResigned = "player_resigned"             // 플레이어 포기
    case timeExpired = "time_expired"                   // 시간 초과
    case draw = "draw"                                  // 무승부
    
    public var displayName: String {
        switch self {
        case .territoryCalculation: return "영역 계산"
        case .isolation: return "격리 완료"
        case .noMovesAvailable: return "이동 불가"
        case .maxTurnsReached: return "최대 턴 도달"
        case .playerResigned: return "플레이어 포기"
        case .timeExpired: return "시간 초과"
        case .draw: return "무승부"
        }
    }
}

// MARK: - Equatable
extension GameResult: Equatable {
    public static func == (lhs: GameResult, rhs: GameResult) -> Bool {
        return lhs.gameID == rhs.gameID &&
               lhs.winnerID == rhs.winnerID &&
               lhs.playerScores == rhs.playerScores &&
               lhs.endReason == rhs.endReason
    }
}

extension GameStats: Equatable {
    public static func == (lhs: GameStats, rhs: GameStats) -> Bool {
        return lhs.totalTurns == rhs.totalTurns &&
               lhs.totalMoves == rhs.totalMoves &&
               lhs.totalWallsPlaced == rhs.totalWallsPlaced &&
               lhs.gameDuration == rhs.gameDuration &&
               lhs.averageThinkingTime == rhs.averageThinkingTime
    }
}

// MARK: - CustomStringConvertible
extension GameResult: CustomStringConvertible {
    public var description: String {
        return "GameResult(gameID: \(gameID), winner: \(winnerID?.uuidString ?? "None"), endReason: \(endReason))"
    }
} 