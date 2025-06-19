import Foundation

/// 바둑돌 엔티티
public struct Stone: Equatable, Hashable {
    public let color: PlayerColor
    public let position: Position
    public let placedAt: Date
    
    public init(color: PlayerColor, position: Position, placedAt: Date = Date()) {
        self.color = color
        self.position = position
        self.placedAt = placedAt
    }
} 
