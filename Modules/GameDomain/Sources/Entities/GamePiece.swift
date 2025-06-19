import Foundation

/// 게임 말을 나타내는 엔티티
public struct GamePiece {
    public let id: UUID
    public let ownerID: UUID
    public let position: GridPosition
    public let isActive: Bool
    public let moveCount: Int
    
    public init(
        id: UUID = UUID(),
        ownerID: UUID,
        position: GridPosition,
        isActive: Bool = true,
        moveCount: Int = 0
    ) {
        self.id = id
        self.ownerID = ownerID
        self.position = position
        self.isActive = isActive
        self.moveCount = moveCount
    }
    
    /// 말이 이동할 수 있는 최대 거리
    public var maxMoveDistance: Int {
        return 2
    }
    
    /// 말이 이동 가능한 위치들을 반환
    public func possibleMoves(on board: GameBoard, excluding walls: [Wall]) -> [GridPosition] {
        var possiblePositions: [GridPosition] = []
        
        // 1칸 이동 가능한 위치들
        let oneStepMoves = position.adjacentPositions()
            .filter { $0.isValid(for: board.size) }
            .filter { !board.hasGamePiece(at: $0) }
            .filter { !isBlockedByWall(from: position, to: $0, walls: walls) }
        
        possiblePositions.append(contentsOf: oneStepMoves)
        
        // 2칸 이동 가능한 위치들
        for oneStepPos in oneStepMoves {
            let twoStepMoves = oneStepPos.adjacentPositions()
                .filter { $0.isValid(for: board.size) }
                .filter { !board.hasGamePiece(at: $0) }
                .filter { !isBlockedByWall(from: oneStepPos, to: $0, walls: walls) }
                .filter { !possiblePositions.contains($0) }
            
            possiblePositions.append(contentsOf: twoStepMoves)
        }
        
        return possiblePositions
    }
    
    /// 벽에 의해 막혀있는지 확인
    private func isBlockedByWall(from: GridPosition, to: GridPosition, walls: [Wall]) -> Bool {
        return walls.contains { wall in
            wall.blocks(movementFrom: from, to: to)
        }
    }
}

// MARK: - Equatable, Hashable
extension GamePiece: Equatable, Hashable {
    public static func == (lhs: GamePiece, rhs: GamePiece) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - CustomStringConvertible
extension GamePiece: CustomStringConvertible {
    public var description: String {
        return "GamePiece(id: \(id), position: \(position), active: \(isActive))"
    }
} 