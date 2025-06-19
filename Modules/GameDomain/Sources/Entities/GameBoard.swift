import Foundation

/// 게임보드 엔티티
public struct GameBoard: Equatable {
    public let size: BoardSize
    public private(set) var stones: [Position: Stone]
    public private(set) var capturedStones: [StoneColor: [Stone]]
    public private(set) var gamePieces: [GamePiece]
    public let grid: [[Cell]]
    
    public init(size: BoardSize) {
        self.size = size
        self.stones = [:]
        self.capturedStones = [.black: [], .white: []]
        self.gamePieces = []
        self.grid = GameBoard.createEmptyGrid(size: size)
    }
    
    /// 빈 격자 생성
    private static func createEmptyGrid(size: BoardSize) -> [[Cell]] {
        let gridSize = size.gridSize
        return (0..<gridSize).map { y in
            (0..<gridSize).map { x in
                Cell(position: GridPosition(x: x, y: y), state: .empty)
            }
        }
    }
    
    // MARK: - Stone 관련 메서드
    public func stone(at position: Position) -> Stone? {
        return stones[position]
    }
    
    public func isEmpty(at position: Position) -> Bool {
        return stones[position] == nil
    }
    
    public mutating func placeStone(_ stone: Stone) {
        stones[stone.position] = stone
    }
    
    public mutating func removeStone(at position: Position) -> Stone? {
        return stones.removeValue(forKey: position)
    }
    
    public mutating func captureStones(_ stones: [Stone]) {
        for stone in stones {
            self.stones.removeValue(forKey: stone.position)
            capturedStones[stone.color]?.append(stone)
        }
    }
    
    public func isValidPosition(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < size.rawValue &&
               position.column >= 0 && position.column < size.rawValue
    }
    
    public func getAdjacentPositions(of position: Position) -> [Position] {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        return directions.compactMap { dr, dc in
            let newPosition = Position(row: position.row + dr, column: position.column + dc)
            return isValidPosition(newPosition) ? newPosition : nil
        }
    }
    
    // MARK: - GamePiece 관련 메서드
    public func hasGamePiece(at position: GridPosition) -> Bool {
        return gamePieces.contains { $0.position == position && $0.isActive }
    }
    
    public func gamePiece(at position: GridPosition) -> GamePiece? {
        return gamePieces.first { $0.position == position && $0.isActive }
    }
    
    public func cell(at position: GridPosition) -> Cell? {
        guard position.isValid(for: size) else { return nil }
        return grid[position.y][position.x]
    }
    
    public func movingPiece(from fromPosition: GridPosition, to toPosition: GridPosition) -> GameBoard {
        guard let pieceIndex = gamePieces.firstIndex(where: { $0.position == fromPosition && $0.isActive }) else {
            return self
        }
        
        var newBoard = self
        newBoard.gamePieces[pieceIndex] = GamePiece(
            id: gamePieces[pieceIndex].id,
            ownerID: gamePieces[pieceIndex].ownerID,
            position: toPosition,
            isActive: gamePieces[pieceIndex].isActive,
            moveCount: gamePieces[pieceIndex].moveCount + 1
        )
        
        return newBoard
    }
    
    public func addingPiece(_ piece: GamePiece) -> GameBoard {
        var newBoard = self
        newBoard.gamePieces.append(piece)
        return newBoard
    }
    
    // MARK: - Territory 계산
    public func calculateTerritories(for players: [Player], walls: [Wall]) -> [UUID: Int] {
        var territories: [UUID: Int] = [:]
        
        for player in players {
            let playerPieces = gamePieces.filter { $0.ownerID == player.id && $0.isActive }
            var totalTerritory = 0
            
            for piece in playerPieces {
                let territory = calculateTerritory(from: piece.position, walls: walls)
                totalTerritory += territory
            }
            
            territories[player.id] = totalTerritory
        }
        
        return territories
    }
    
    private func calculateTerritory(from startPosition: GridPosition, walls: [Wall]) -> Int {
        var visited: Set<GridPosition> = []
        var territory = 0
        var queue: [GridPosition] = [startPosition]
        
        while !queue.isEmpty {
            let currentPosition = queue.removeFirst()
            
            if visited.contains(currentPosition) {
                continue
            }
            
            visited.insert(currentPosition)
            territory += 1
            
            for adjacentPosition in currentPosition.adjacentPositions() {
                if adjacentPosition.isValid(for: size) &&
                   !visited.contains(adjacentPosition) &&
                   !hasGamePiece(at: adjacentPosition) &&
                   !isBlockedByWall(from: currentPosition, to: adjacentPosition, walls: walls) {
                    queue.append(adjacentPosition)
                }
            }
        }
        
        return territory
    }
    
    private func isBlockedByWall(from: GridPosition, to: GridPosition, walls: [Wall]) -> Bool {
        return walls.contains { wall in
            wall.blocks(movementFrom: from, to: to)
        }
    }
}

/// 게임 보드 셀
public struct Cell: Equatable {
    public let position: GridPosition
    public let state: CellState
    
    public init(position: GridPosition, state: CellState) {
        self.position = position
        self.state = state
    }
}

/// 셀 상태
public enum CellState: String, CaseIterable {
    case empty = "empty"
    case occupied = "occupied"
    case highlighted = "highlighted"
    
    public var displayName: String {
        switch self {
        case .empty: return "빈 칸"
        case .occupied: return "점유됨"
        case .highlighted: return "강조됨"
        }
    }
} 
