import GameDomain

// MARK: - GameBoard Component + GameSettings

extension GameBoardComponent {
    
    var gameSettings: GameSettings {
        // TODO: GameSettings를 Component에서 제공하도록 구현
        // 현재는 Builder에서 직접 전달받고 있음
        fatalError("GameSettings should be provided through Builder")
    }
    
    // MARK: - Game State Management
    
    var initialGameState: GameState {
        // GameSettings를 기반으로 초기 게임 상태 생성
        return GameState.initial(
            boardSize: gameSettings.boardSize,
            playerCount: gameSettings.playerCount
        )
    }
    
    // MARK: - Game Configuration
    
    var boardConfiguration: BoardConfiguration {
        return BoardConfiguration(
            size: gameSettings.boardSize,
            theme: gameSettings.colorTheme
        )
    }
    
    var playerConfiguration: PlayerConfiguration {
        return PlayerConfiguration(
            count: gameSettings.playerCount,
            aiDifficulty: gameSettings.aiDifficulty,
            timeLimit: gameSettings.timeLimit
        )
    }
}

// MARK: - Configuration Models

struct BoardConfiguration {
    let size: BoardSize
    let theme: ColorTheme
}

struct PlayerConfiguration {
    let count: Int
    let aiDifficulty: AIDifficulty?
    let timeLimit: TimeLimit
} 