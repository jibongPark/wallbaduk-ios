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
        
        return Single.create { observer in
            // 이동 유효성 검사
            guard let position = move.position else {
                observer(.failure(GameError.invalidMove("Position is required for placing stone")))
                return Disposables.create()
            }
            
            guard gameState.board.isValidPosition(position) else {
                observer(.failure(GameError.invalidMove("Invalid position")))
                return Disposables.create()
            }
            
            guard gameState.board.isEmpty(at: position) else {
                observer(.failure(GameError.invalidMove("Position already occupied")))
                return Disposables.create()
            }
            
            // 새로운 게임 상태 생성
            var newGameState = gameState
            let piece = GamePiece(
                ownerID: move.player.id,
                position: position.toGridPosition()
            )
            newGameState.board.placePiece(piece, at: position)
            newGameState.currentPlayerIndex = (gameState.currentPlayerIndex + 1) % gameState.players.count
            
            // 상태 저장
            let disposable = self.gameRepository.saveGameState(newGameState)
                .subscribe(
                    onSuccess: { _ in observer(.success(newGameState)) },
                    onFailure: { error in observer(.failure(error)) }
                )
            
            return disposable
        }
    }
}

 
