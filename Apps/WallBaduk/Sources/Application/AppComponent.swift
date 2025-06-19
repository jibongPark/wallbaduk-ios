import RIBs
import GameDomain
//import GameData

protocol AppDependency: Dependency {
    // 외부 의존성 (없음)
}

final class AppComponent: Component<AppDependency> {
    
    // MARK: - GameDomain Dependencies
    lazy var gameRepository: GameRepository = GameRepositoryImpl()
    lazy var gameHistoryRepository: GameHistoryRepository = GameHistoryRepositoryImpl()
    
    // MARK: - UseCases
    lazy var startGameUseCase: StartGameUseCase = StartGameUseCaseImpl(
        gameRepository: gameRepository
    )
    
    lazy var movePieceUseCase: MovePieceUseCase = MovePieceUseCaseImpl(
        gameRepository: gameRepository
    )
    
    lazy var buildWallUseCase: BuildWallUseCase = BuildWallUseCaseImpl(
        gameRepository: gameRepository
    )
    
    lazy var calculateScoreUseCase: CalculateScoreUseCase = CalculateScoreUseCaseImpl()
}

// MARK: - Placeholder Implementations
protocol GameRepository {}
protocol GameHistoryRepository {}

protocol StartGameUseCase {}
protocol MovePieceUseCase {}
protocol BuildWallUseCase {}
protocol CalculateScoreUseCase {}

class GameRepositoryImpl: GameRepository {}
class GameHistoryRepositoryImpl: GameHistoryRepository {}

class StartGameUseCaseImpl: StartGameUseCase {
    private let gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
    }
}

class MovePieceUseCaseImpl: MovePieceUseCase {
    private let gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
    }
}

class BuildWallUseCaseImpl: BuildWallUseCase {
    private let gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
    }
}

class CalculateScoreUseCaseImpl: CalculateScoreUseCase {} 
