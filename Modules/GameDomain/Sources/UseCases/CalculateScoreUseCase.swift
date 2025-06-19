import Foundation
import RxSwift

public protocol CalculateScoreUseCaseProtocol {
    func execute(gameState: GameState) -> Single<[UUID: Int]>
}

public final class CalculateScoreUseCase: CalculateScoreUseCaseProtocol {
    
    public init() {}
    
    public func execute(gameState: GameState) -> Single<[UUID: Int]> {
        return Single.create { observer in
            let scores = self.calculateTerritories(for: gameState)
            observer(.success(scores))
            return Disposables.create()
        }
    }
    
    private func calculateTerritories(for gameState: GameState) -> [UUID: Int] {
        var playerTerritories: [UUID: Int] = [:]
        
        // 각 플레이어별로 영역 계산
        for player in gameState.players {
            let playerPieces = gameState.board.getActivePieces(for: player.id)
            var totalTerritory = 0
            
            // 각 말별로 연결된 영역 계산
            for piece in playerPieces {
                let territorySize = calculateConnectedTerritory(
                    from: piece.position,
                    gameState: gameState,
                    playerID: player.id
                )
                totalTerritory += territorySize
            }
            
            playerTerritories[player.id] = totalTerritory
        }
        
        return playerTerritories
    }
    
    private func calculateConnectedTerritory(
        from startPosition: GridPosition,
        gameState: GameState,
        playerID: UUID
    ) -> Int {
        var visited: Set<GridPosition> = []
        var territorySize = 0
        
        // BFS를 사용하여 연결된 영역 탐색
        var queue: [GridPosition] = [startPosition]
        visited.insert(startPosition)
        
        while !queue.isEmpty {
            let currentPosition = queue.removeFirst()
            territorySize += 1
            
            // 인접한 위치들 확인
            let adjacentPositions = getAdjacentPositions(
                of: currentPosition,
                boardSize: gameState.boardSize
            )
            
            for adjacentPos in adjacentPositions {
                // 이미 방문했거나 유효하지 않은 위치는 스킵
                guard !visited.contains(adjacentPos),
                      adjacentPos.isValid(for: gameState.boardSize) else {
                    continue
                }
                
                // 벽으로 차단되었는지 확인
                if isPathBlocked(
                    from: currentPosition,
                    to: adjacentPos,
                    walls: gameState.walls
                ) {
                    continue
                }
                
                // 다른 플레이어의 말이 있는지 확인
                if let piece = gameState.board.getPiece(at: adjacentPos),
                   piece.ownerID != playerID {
                    continue
                }
                
                // 빈 칸이거나 같은 플레이어의 말이면 영역에 포함
                visited.insert(adjacentPos)
                queue.append(adjacentPos)
            }
        }
        
        return territorySize
    }
    
    private func getAdjacentPositions(
        of position: GridPosition,
        boardSize: BoardSize
    ) -> [GridPosition] {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        return directions.compactMap { dx, dy in
            let newPosition = GridPosition(
                x: position.x + dx,
                y: position.y + dy
            )
            return newPosition.isValid(for: boardSize) ? newPosition : nil
        }
    }
    
    private func isPathBlocked(
        from start: GridPosition,
        to end: GridPosition,
        walls: [Wall]
    ) -> Bool {
        // 벽이 두 위치 사이의 경로를 차단하는지 확인
        for wall in walls {
            if wall.blocksPath(from: start, to: end) {
                return true
            }
        }
        return false
    }
}

// MARK: - Territory Calculation Result
public struct TerritoryResult {
    public let playerID: UUID
    public let territorySize: Int
    public let connectedPositions: Set<GridPosition>
    
    public init(playerID: UUID, territorySize: Int, connectedPositions: Set<GridPosition>) {
        self.playerID = playerID
        self.territorySize = territorySize
        self.connectedPositions = connectedPositions
    }
} 