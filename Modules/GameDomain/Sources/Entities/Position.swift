import Foundation

/// 격자 위치를 나타내는 구조체
public struct GridPosition {
    public let x: Int
    public let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    /// 유효한 위치인지 확인
    public func isValid(for boardSize: BoardSize) -> Bool {
        let size = boardSize.gridSize
        return x >= 0 && x < size && y >= 0 && y < size
    }
    
    /// 인접한 위치들 반환
    public func adjacentPositions() -> [GridPosition] {
        return [
            GridPosition(x: x - 1, y: y), // 왼쪽
            GridPosition(x: x + 1, y: y), // 오른쪽
            GridPosition(x: x, y: y - 1), // 위
            GridPosition(x: x, y: y + 1)  // 아래
        ]
    }
    
    /// 거리 계산 (맨하탄 거리)
    public func distance(to position: GridPosition) -> Int {
        return abs(x - position.x) + abs(y - position.y)
    }
}

/// 벽바둑 게임용 위치 - GridPosition과 동일하지만 다른 좌표계 지원
public struct Position {
    public let row: Int
    public let column: Int
    
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    
    /// GridPosition으로 변환
    public var gridPosition: GridPosition {
        return GridPosition(x: column, y: row)
    }
    
    /// GridPosition으로 변환하는 메소드
    public func toGridPosition() -> GridPosition {
        return GridPosition(x: column, y: row)
    }
    
    /// GridPosition에서 변환
    public init(gridPosition: GridPosition) {
        self.row = gridPosition.y
        self.column = gridPosition.x
    }
    
    /// 유효한 위치인지 확인
    public func isValid(for boardSize: BoardSize) -> Bool {
        let size = boardSize.gridSize
        return row >= 0 && row < size && column >= 0 && column < size
    }
    
    /// 인접한 위치들 반환
    public func adjacentPositions() -> [Position] {
        return [
            Position(row: row - 1, column: column), // 위
            Position(row: row + 1, column: column), // 아래
            Position(row: row, column: column - 1), // 왼쪽
            Position(row: row, column: column + 1)  // 오른쪽
        ]
    }
    
    /// 거리 계산 (맨하탄 거리)
    public func distance(to position: Position) -> Int {
        return abs(row - position.row) + abs(column - position.column)
    }
}

// MARK: - Equatable, Hashable
extension GridPosition: Equatable, Hashable {
    public static func == (lhs: GridPosition, rhs: GridPosition) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension Position: Equatable, Hashable {
    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.column == rhs.column
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}

// MARK: - CustomStringConvertible
extension GridPosition: CustomStringConvertible {
    public var description: String {
        return "(\(x), \(y))"
    }
}

extension Position: CustomStringConvertible {
    public var description: String {
        return "(\(row), \(column))"
    }
} 