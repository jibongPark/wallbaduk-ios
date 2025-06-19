import Foundation

/// 게임 이동 타입
public enum MoveType: String, CaseIterable {
    case place = "place"
    case pass = "pass"
    case resign = "resign"
}

/// 게임 이동 엔티티
public struct GameMove: Equatable, Hashable {
    public let id: UUID
    public let player: Player
    public let type: MoveType
    public let position: Position?
    public let timestamp: Date
    public let moveNumber: Int
    
    public init(
        id: UUID = UUID(),
        player: Player,
        type: MoveType,
        position: Position? = nil,
        timestamp: Date = Date(),
        moveNumber: Int
    ) {
        self.id = id
        self.player = player
        self.type = type
        self.position = position
        self.timestamp = timestamp
        self.moveNumber = moveNumber
    }
    
    /// 돌 놓기 이동 생성
    public static func place(player: Player, at position: Position, moveNumber: Int) -> GameMove {
        return GameMove(
            player: player,
            type: .place,
            position: position,
            moveNumber: moveNumber
        )
    }
    
    /// 패스 이동 생성
    public static func pass(player: Player, moveNumber: Int) -> GameMove {
        return GameMove(
            player: player,
            type: .pass,
            moveNumber: moveNumber
        )
    }
    
    /// 기권 이동 생성
    public static func resign(player: Player, moveNumber: Int) -> GameMove {
        return GameMove(
            player: player,
            type: .resign,
            moveNumber: moveNumber
        )
    }
} 