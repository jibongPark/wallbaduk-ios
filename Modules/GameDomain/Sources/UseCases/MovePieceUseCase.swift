import Foundation
import RxSwift

public protocol MovePieceUseCaseProtocol {
    func execute(move: GameMove, gameState: GameState) -> Single<GameState>
}

public final class MovePieceUseCase: MovePieceUseCaseProtocol {
    private let gameRepository: GameRepositoryProtocol
    
    public init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    public func execute(move: GameMove, gameState: GameState) -> Single<GameState> {
        return Single.create { observer in
            // 말 이동 타입 확인
            guard move.type == .move else {
                observer(.failure(GameError.invalidMove("Move type must be 'move'")))
                return Disposables.create()
            }
            
            // 시작 위치와 목표 위치 확인
            guard let fromPosition = move.fromPosition,
                  let toPosition = move.toPosition else {
                observer(.failure(GameError.invalidMove("From and to positions are required for move")))
                return Disposables.create()
            }
            
            // 위치 유효성 검사
            guard gameState.board.isValidPosition(fromPosition),
                  gameState.board.isValidPosition(toPosition) else {
                observer(.failure(GameError.invalidMove("Invalid position")))
                return Disposables.create()
            }
            
            // 목표 위치가 비어있는지 확인
            guard gameState.board.isEmpty(at: toPosition) else {
                observer(.failure(GameError.invalidMove("Target position is occupied")))
                return Disposables.create()
            }
            
            // 시작 위치에 현재 플레이어의 말이 있는지 확인
            guard let piece = gameState.board.getPiece(at: fromPosition),
                  piece.ownerID == move.player.id else {
                observer(.failure(GameError.invalidMove("No valid piece found at from position")))
                return Disposables.create()
            }
            
            // 이동 거리 검사 (최대 2칸)
            let distance = fromPosition.distance(to: toPosition)
            guard distance <= piece.maxMoveDistance else {
                observer(.failure(GameError.invalidMove("Move distance exceeds maximum allowed (\(piece.maxMoveDistance) squares)")))
                return Disposables.create()
            }
            
            // 벽에 의한 차단 확인
            let possibleMoves = piece.possibleMoves(on: gameState.board, excluding: gameState.walls)
            guard possibleMoves.contains(toPosition.gridPosition) else {
                observer(.failure(GameError.invalidMove("Move is blocked by walls")))
                return Disposables.create()
            }
            
            // 새로운 게임 상태 생성
            var newGameState = gameState
            
            // 말을 새 위치로 이동
            _ = newGameState.board.removePiece(at: fromPosition)
            let movedPiece = GamePiece(
                id: piece.id,
                ownerID: piece.ownerID,
                position: toPosition.gridPosition,
                isActive: piece.isActive,
                moveCount: piece.moveCount + 1
            )
            newGameState.board.placePiece(movedPiece, at: toPosition)
            
            // 턴 변경
            newGameState.currentPlayerIndex = (gameState.currentPlayerIndex + 1) % gameState.players.count
            newGameState.turnCount += 1
            
            // 이동 기록 추가
            newGameState.moves.append(move)
            
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