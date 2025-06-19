import Foundation

/// 벽을 나타내는 엔티티
public struct Wall {
    public let id: UUID
    public let position: GridPosition
    public let orientation: WallOrientation
    public let ownerID: UUID
    public let createdAt: Date
    
    public init(
        id: UUID = UUID(),
        position: GridPosition,
        orientation: WallOrientation,
        ownerID: UUID,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.position = position
        self.orientation = orientation
        self.ownerID = ownerID
        self.createdAt = createdAt
    }
    
    /// 벽이 두 위치 사이의 이동을 막는지 확인
    public func blocks(movementFrom: GridPosition, to: GridPosition) -> Bool {
        switch orientation {
        case .horizontal:
            return blocksHorizontalMovement(from: movementFrom, to: to)
        case .vertical:
            return blocksVerticalMovement(from: movementFrom, to: to)
        }
    }
    
    /// 수평 벽이 이동을 막는지 확인
    private func blocksHorizontalMovement(from: GridPosition, to: GridPosition) -> Bool {
        // 세로 이동을 막는 수평 벽
        if from.x == to.x && abs(from.y - to.y) == 1 {
            let wallY = max(from.y, to.y)
            return position.x == from.x && position.y == wallY
        }
        return false
    }
    
    /// 수직 벽이 이동을 막는지 확인
    private func blocksVerticalMovement(from: GridPosition, to: GridPosition) -> Bool {
        // 가로 이동을 막는 수직 벽
        if from.y == to.y && abs(from.x - to.x) == 1 {
            let wallX = max(from.x, to.x)
            return position.y == from.y && position.x == wallX
        }
        return false
    }
    
    /// 벽이 차지하는 격자선 위치들 반환
    public func occupiedGridLines() -> [GridPosition] {
        switch orientation {
        case .horizontal:
            return [position]
        case .vertical:
            return [position]
        }
    }
}

/// 벽의 방향
public enum WallOrientation: String, CaseIterable {
    case horizontal = "horizontal"
    case vertical = "vertical"
    
    public var displayName: String {
        switch self {
        case .horizontal: return "수평"
        case .vertical: return "수직"
        }
    }
}

// MARK: - Equatable, Hashable
extension Wall: Equatable, Hashable {
    public static func == (lhs: Wall, rhs: Wall) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - CustomStringConvertible
extension Wall: CustomStringConvertible {
    public var description: String {
        return "Wall(id: \(id), position: \(position), orientation: \(orientation))"
    }
} 