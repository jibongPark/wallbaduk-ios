import Foundation
import RxSwift

public protocol BuildWallUseCaseProtocol {
    func execute(wallPosition: GridPosition, orientation: WallOrientation, gameState: GameState) -> Single<GameState>
}

public final class BuildWallUseCase: BuildWallUseCaseProtocol {
    private let gameRepository: GameRepositoryProtocol
    
    public init(gameRepository: GameRepositoryProtocol) {
        self.gameRepository = gameRepository
    }
    
    public func execute(wallPosition: GridPosition, orientation: WallOrientation, gameState: GameState) -> Single<GameState> {
        return Single.create { observer in
            // 현재 플레이어 확인
            guard let currentPlayer = gameState.currentPlayer else {
                observer(.failure(GameError.invalidMove("현재 플레이어를 찾을 수 없습니다")))
                return Disposables.create()
            }
            
            // 벽 설치 유효성 검사
            do {
                try self.validateWallPlacement(
                    at: wallPosition,
                    orientation: orientation,
                    gameState: gameState,
                    player: currentPlayer
                )
            } catch {
                observer(.failure(error))
                return Disposables.create()
            }
            
            // 새로운 벽 생성
            let newWall = Wall(
                id: UUID(),
                position: wallPosition,
                orientation: orientation,
                ownerID: currentPlayer.id,
                createdAt: Date()
            )
            
            // 새로운 게임 상태 생성
            var newGameState = gameState
            newGameState.walls.append(newWall)
            newGameState.turnCount += 1
            newGameState.updatedAt = Date()
            
            // 턴 변경 (벽 설치는 선택적이므로 이동 후에 실행됨)
            // 게임 종료 조건 확인
            if self.checkGameEndConditions(gameState: newGameState) {
                newGameState.gamePhase = .finished
            }
            
            // 상태 저장
            let disposable = self.gameRepository.saveGameState(newGameState)
                .subscribe(
                    onSuccess: { _ in observer(.success(newGameState)) },
                    onFailure: { error in observer(.failure(error)) }
                )
            
            return disposable
        }
    }
    
    private func validateWallPlacement(
        at position: GridPosition,
        orientation: WallOrientation,
        gameState: GameState,
        player: Player
    ) throws {
        // 게임 상태 확인
        guard gameState.gamePhase == .playing else {
            throw GameError.invalidMove("게임이 진행 중이 아닙니다")
        }
        
        // 위치 유효성 확인
        guard position.isValid(for: gameState.boardSize) else {
            throw GameError.invalidMove("잘못된 벽 위치입니다")
        }
        
        // 중복 벽 확인
        let existingWall = gameState.walls.first { wall in
            wall.position == position && wall.orientation == orientation
        }
        guard existingWall == nil else {
            throw GameError.invalidMove("해당 위치에 이미 벽이 있습니다")
        }
        
        // 플레이어 말 근처 확인 (벽바둑 규칙: 자신의 말 근처에만 벽 설치 가능)
        let playerPieces = gameState.board.getActivePieces(for: player.id)
        let canPlaceWall = playerPieces.contains { piece in
            isWallAdjacentToPiece(wallPosition: position, piecePosition: piece.position)
        }
        
        guard canPlaceWall else {
            throw GameError.invalidMove("자신의 말 근처에만 벽을 설치할 수 있습니다")
        }
    }
    
    private func isWallAdjacentToPiece(wallPosition: GridPosition, piecePosition: GridPosition) -> Bool {
        let dx = abs(wallPosition.x - piecePosition.x)
        let dy = abs(wallPosition.y - piecePosition.y)
        return dx <= 1 && dy <= 1
    }
    
    private func checkGameEndConditions(gameState: GameState) -> Bool {
        // 모든 말이 격리되었는지 확인
        let allPieces = gameState.board.getAllActivePieces()
        
        for piece in allPieces {
            let availableMoves = getAvailableMoves(for: piece, in: gameState)
            if !availableMoves.isEmpty {
                return false // 아직 이동 가능한 말이 있음
            }
        }
        
        return true // 모든 말이 이동 불가능하면 게임 종료
    }
    
    private func getAvailableMoves(for piece: GamePiece, in gameState: GameState) -> [GridPosition] {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        var availableMoves: [GridPosition] = []
        
        for (dx, dy) in directions {
            for distance in 1...2 { // 최대 2칸 이동
                let newX = piece.position.x + dx * distance
                let newY = piece.position.y + dy * distance
                let newPosition = GridPosition(x: newX, y: newY)
                
                guard newPosition.isValid(for: gameState.boardSize) else { break }
                guard gameState.board.isEmpty(at: newPosition) else { break }
                
                // 벽으로 차단되었는지 확인
                if !isPathBlocked(from: piece.position, to: newPosition, walls: gameState.walls) {
                    availableMoves.append(newPosition)
                }
            }
        }
        
        return availableMoves
    }
    
    private func isPathBlocked(from start: GridPosition, to end: GridPosition, walls: [Wall]) -> Bool {
        // 간단한 구현: 경로상의 벽 확인
        // 실제로는 더 정교한 벽 차단 알고리즘이 필요
        for wall in walls {
            if wall.blocksPath(from: start, to: end) {
                return true
            }
        }
        return false
    }
} 