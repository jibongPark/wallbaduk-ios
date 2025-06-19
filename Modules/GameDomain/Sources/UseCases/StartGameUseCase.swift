import Foundation
import RxSwift

public protocol StartGameUseCaseProtocol {
    func execute(settings: GameSettings) -> Single<GameState>
}

public final class StartGameUseCase: StartGameUseCaseProtocol {
    private let gameRepository: GameRepositoryProtocol
    
    public init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    public func execute(settings: GameSettings) -> Single<GameState> {
        return Single.create { observer in
            // 게임 설정 유효성 검사
            guard settings.playerCount >= 2 && settings.playerCount <= 4 else {
                observer(.failure(GameError.invalidGameSettings("플레이어 수는 2-4명이어야 합니다")))
                return Disposables.create()
            }
            
            // 초기 게임 상태 생성
            let gameState = self.createInitialGameState(from: settings)
            
            // 게임 상태 저장
            let disposable = self.gameRepository.saveGameState(gameState)
                .subscribe(
                    onSuccess: { _ in observer(.success(gameState)) },
                    onFailure: { error in observer(.failure(error)) }
                )
            
            return disposable
        }
    }
    
    private func createInitialGameState(from settings: GameSettings) -> GameState {
        // 플레이어 생성
        let playerColors: [PlayerColor] = [.black, .white, .blue, .green]
        let players = (0..<settings.playerCount).map { index in
            Player(
                id: UUID(),
                name: settings.playerNames?[safe: index] ?? "플레이어 \(index + 1)",
                color: playerColors[index],
                pieces: [],
                score: 0,
                isAI: settings.aiPlayers?.contains(index) ?? false,
                aiDifficulty: settings.aiPlayers?.contains(index) == true ? settings.aiDifficulty : nil
            )
        }
        
        // 빈 게임 보드 생성
        let board = GameBoard(size: settings.boardSize)
        
        return GameState(
            id: UUID(),
            boardSize: settings.boardSize,
            players: players,
            currentPlayerIndex: 0,
            board: board,
            walls: [],
            moves: [],
            turnCount: 0,
            gamePhase: .setup,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}

// Array safe subscript extension
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
} 