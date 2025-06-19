import Foundation

/// 게임보드 엔티티
public struct GameBoard: Equatable {
    public let size: BoardSize
    public private(set) var pieces: [GamePiece]
    public let grid: [[Cell]]
    
    public init(size: BoardSize) {
        self.size = size
        self.pieces = []
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
    
    // MARK: - GamePiece 관련 메서드
    
    /// Position에서 GamePiece 가져오기
    public func getPiece(at position: Position) -> GamePiece? {
        let gridPos = position.toGridPosition()
        return pieces.first { $0.position == gridPos && $0.isActive }
    }
    
    /// GridPosition에서 GamePiece 가져오기
    public func getPiece(at position: GridPosition) -> GamePiece? {
        return pieces.first { $0.position == position && $0.isActive }
    }
    
    /// 특정 위치에 활성 GamePiece가 있는지 확인 (Position)
    public func hasPiece(at position: Position) -> Bool {
        return getPiece(at: position) != nil
    }
    
    /// 특정 위치에 활성 GamePiece가 있는지 확인 (GridPosition)
    public func hasPiece(at position: GridPosition) -> Bool {
        return getPiece(at: position) != nil
    }
    
    /// 특정 위치가 비어있는지 확인 (Position)
    public func isEmpty(at position: Position) -> Bool {
        return !hasPiece(at: position)
    }
    
    /// 특정 위치가 비어있는지 확인 (GridPosition)
    public func isEmpty(at position: GridPosition) -> Bool {
        return !hasPiece(at: position)
    }
    
    /// GamePiece를 특정 위치에 배치
    public mutating func placePiece(_ piece: GamePiece, at position: Position) {
        let gridPos = position.toGridPosition()
        let newPiece = GamePiece(
            id: piece.id,
            ownerID: piece.ownerID,
            position: gridPos,
            isActive: piece.isActive,
            moveCount: piece.moveCount
        )
        pieces.append(newPiece)
    }
    
    /// GamePiece를 특정 위치에 배치 (GridPosition)
    public mutating func placePiece(_ piece: GamePiece, at position: GridPosition) {
        let newPiece = GamePiece(
            id: piece.id,
            ownerID: piece.ownerID,
            position: position,
            isActive: piece.isActive,
            moveCount: piece.moveCount
        )
        pieces.append(newPiece)
    }
    
    /// 특정 위치에서 GamePiece 제거
    public mutating func removePiece(at position: Position) -> GamePiece? {
        let gridPos = position.toGridPosition()
        if let index = pieces.firstIndex(where: { $0.position == gridPos && $0.isActive }) {
            let piece = pieces[index]
            pieces.remove(at: index)
            return piece
        }
        return nil
    }
    
    /// 특정 위치에서 GamePiece 제거 (GridPosition)
    public mutating func removePiece(at position: GridPosition) -> GamePiece? {
        if let index = pieces.firstIndex(where: { $0.position == position && $0.isActive }) {
            let piece = pieces[index]
            pieces.remove(at: index)
            return piece
        }
        return nil
    }
    
    /// GamePiece 추가
    public mutating func addPiece(_ piece: GamePiece) {
        pieces.append(piece)
    }
    
    /// 특정 플레이어의 활성 GamePiece들 가져오기
    public func getActivePieces(for playerID: UUID) -> [GamePiece] {
        return pieces.filter { $0.ownerID == playerID && $0.isActive }
    }
    
    /// 모든 활성 GamePiece들 가져오기
    public func getAllActivePieces() -> [GamePiece] {
        return pieces.filter { $0.isActive }
    }
    
    /// Position이 유효한지 확인
    public func isValidPosition(_ position: Position) -> Bool {
        return position.row >= 0 && position.row < size.rawValue &&
               position.column >= 0 && position.column < size.rawValue
    }
    
    /// GridPosition이 유효한지 확인
    public func isValidPosition(_ position: GridPosition) -> Bool {
        return position.isValid(for: size)
    }
    
    /// Position의 인접 위치들 가져오기
    public func getAdjacentPositions(of position: Position) -> [Position] {
        let directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
        return directions.compactMap { dr, dc in
            let newPosition = Position(row: position.row + dr, column: position.column + dc)
            return isValidPosition(newPosition) ? newPosition : nil
        }
    }
    
    /// GridPosition의 인접 위치들 가져오기
    public func getAdjacentGridPositions(of position: GridPosition) -> [GridPosition] {
        return position.adjacentPositions().filter { isValidPosition($0) }
    }

    // MARK: - 기존 메서드들 (호환성 유지)
    public func hasGamePiece(at position: GridPosition) -> Bool {
        return hasPiece(at: position)
    }
    
    public func gamePiece(at position: GridPosition) -> GamePiece? {
        return getPiece(at: position)
    }
    
    public func cell(at position: GridPosition) -> Cell? {
        guard position.isValid(for: size) else { return nil }
        return grid[position.y][position.x]
    }
    
    public func movingPiece(from fromPosition: GridPosition, to toPosition: GridPosition) -> GameBoard {
        guard let pieceIndex = pieces.firstIndex(where: { $0.position == fromPosition && $0.isActive }) else {
            return self
        }
        
        var newBoard = self
        newBoard.pieces[pieceIndex] = GamePiece(
            id: pieces[pieceIndex].id,
            ownerID: pieces[pieceIndex].ownerID,
            position: toPosition,
            isActive: pieces[pieceIndex].isActive,
            moveCount: pieces[pieceIndex].moveCount + 1
        )
        
        return newBoard
    }
    
    public func addingPiece(_ piece: GamePiece) -> GameBoard {
        var newBoard = self
        newBoard.pieces.append(piece)
        return newBoard
    }
    
    // MARK: - Territory 계산
    public func calculateTerritories(for players: [Player], walls: [Wall]) -> [UUID: Int] {
        var territories: [UUID: Int] = [:]
        
        for player in players {
            let playerPieces = pieces.filter { $0.ownerID == player.id && $0.isActive }
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
