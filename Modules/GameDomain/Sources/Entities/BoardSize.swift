import Foundation

/// 게임보드 크기
public enum BoardSize: Int, Equatable, CaseIterable {
    case small = 9
    case medium = 13
    case large = 19
    
    public var description: String {
        return "\(rawValue)x\(rawValue)"
    }
    
    public var gridSize: Int {
        return rawValue
    }
    
    public var displayName: String {
        switch self {
        case .small: return "소형 (9x9)"
        case .medium: return "중형 (13x13)"
        case .large: return "대형 (19x19)"
        }
    }
} 