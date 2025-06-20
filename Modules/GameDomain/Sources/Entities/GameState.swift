import Foundation

/// 게임 상태를 나타내는 엔티티
public struct GameState {
    public let id: UUID
    public let boardSize: BoardSize
    public let players: [Player]
    public var currentPlayerIndex: Int
    public var board: GameBoard
    public var walls: [Wall]
    public var moves: [GameMove]
    public var turnCount: Int
    public var gamePhase: GamePhase
    public let createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        boardSize: BoardSize,
        players: [Player],
        currentPlayerIndex: Int = 0,
        board: GameBoard,
        walls: [Wall] = [],
        moves: [GameMove] = [],
        turnCount: Int = 0,
        gamePhase: GamePhase = .playing,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.boardSize = boardSize
        self.players = players
        self.currentPlayerIndex = currentPlayerIndex
        self.board = board
        self.walls = walls
        self.moves = moves
        self.turnCount = turnCount
        self.gamePhase = gamePhase
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    /// 현재 플레이어 반환
    public var currentPlayer: Player? {
        guard currentPlayerIndex >= 0 && currentPlayerIndex < players.count else {
            return nil
        }
        return players[currentPlayerIndex]
    }
    
    /// 다음 플레이어로 턴 전환
    public func nextTurn() -> GameState {
        let nextIndex = (currentPlayerIndex + 1) % players.count
        return GameState(
            id: id,
            boardSize: boardSize,
            players: players,
            currentPlayerIndex: nextIndex,
            board: board,
            walls: walls,
            moves: moves,
            turnCount: turnCount + 1,
            gamePhase: gamePhase,
            createdAt: createdAt,
            updatedAt: Date()
        )
    }
    
    /// 게임이 끝났는지 확인
    public var isGameFinished: Bool {
        return gamePhase == .finished
    }
    
    /// 초기 게임 상태 생성
    public static func initial(boardSize: BoardSize, playerCount: Int) -> GameState {
        // 기본 플레이어들 생성
        let playerColors: [PlayerColor] = [.black, .white, .blue, .green]
        let players = (0..<playerCount).map { index in
            Player(
                id: UUID(),
                name: "플레이어 \(index + 1)",
                color: playerColors[index],
                pieces: [],
                score: 0,
                isAI: false,
                aiDifficulty: nil
            )
        }
        
        // 빈 게임 보드 생성
        let board = GameBoard(size: boardSize)
        
        return GameState(
            boardSize: boardSize,
            players: players,
            currentPlayerIndex: 0,
            board: board,
            walls: [],
            moves: [],
            turnCount: 0,
            gamePhase: .setup
        )
    }
}

/// 게임 진행 단계
public enum GamePhase: String, CaseIterable {
    case setup      = "setup"
    case playing    = "playing"
    case finished   = "finished"
    case paused     = "paused"
} 
