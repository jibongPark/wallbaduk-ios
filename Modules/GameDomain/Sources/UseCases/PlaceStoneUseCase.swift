import Foundation
import RxSwift

public protocol PlaceStoneUseCaseProtocol {
    func execute(move: GameMove, gameState: GameState) -> Single<GameState>
}

public final class PlaceStoneUseCase: PlaceStoneUseCaseProtocol {
    private let gameRepository: GameRepositoryProtocol
    
    public init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    public func execute(move: GameMove, gameState: GameState) -> Single<GameState> {
        return Single.create { single in
            // 이동 유효성 검사
            guard let position = move.position else {
                single(.failure(GameError.invalidMove("Position is required for placing stone")))
                return Disposables.create()
            }
            
            guard gameState.board.isValidPosition(position) else {
                single(.failure(GameError.invalidMove("Invalid position")))
                return Disposables.create()
            }
            
            guard gameState.board.isEmpty(at: position) else {
                single(.failure(GameError.invalidMove("Position already occupied")))
                return Disposables.create()
            }
            
            // 새로운 게임 상태 생성
            var newGameState = gameState
            let stone = Stone(color: move.player.stoneColor, position: position)
            newGameState.board.placeStone(stone)
            newGameState.moves.append(move)
            newGameState.currentPlayerIndex = (gameState.currentPlayerIndex + 1) % gameState.players.count
            
            // 상태 저장
            self.gameRepository.saveGameState(newGameState)
                .subscribe(
                    onSuccess: { _ in single(.success(newGameState)) },
                    onFailure: { error in single(.failure(error)) }
                )
                .disposed(by: DisposeBag())
            
            return Disposables.create()
        }
    }
}

public enum GameError: Error, LocalizedError {
    case invalidMove(String)
    case gameNotFound
    case saveError
    
    public var errorDescription: String? {
        switch self {
        case .invalidMove(let message):
            return "Invalid move: \(message)"
        case .gameNotFound:
            return "Game not found"
        case .saveError:
            return "Failed to save game"
        }
    }
} 