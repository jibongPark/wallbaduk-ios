import Foundation

/// 바둑돌 색상
public enum StoneColor: String, CaseIterable {
    case black = "black"
    case white = "white"
    
    public var opponent: StoneColor {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
}

/// 바둑돌 엔티티
public struct Stone: Equatable, Hashable {
    public let color: StoneColor
    public let position: Position
    public let placedAt: Date
    
    public init(color: StoneColor, position: Position, placedAt: Date = Date()) {
        self.color = color
        self.position = position
        self.placedAt = placedAt
    }
} 