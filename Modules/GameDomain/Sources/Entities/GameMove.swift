import Foundation

/// 게임 이동 타입
public enum MoveType: String, CaseIterable {
    case place = "place"
    case move = "move"
}

/// 게임 이동 엔티티
public struct GameMove: Equatable, Hashable {
    public let id: UUID
    public let player: Player
    public let type: MoveType
    public let position: Position?
    public let fromPosition: Position? // 말 이동시 시작 위치
    public let toPosition: Position?   // 말 이동시 목표 위치
    public let timestamp: Date
    public let moveNumber: Int
    
    public init(
        id: UUID = UUID(),
        player: Player,
        type: MoveType,
        position: Position? = nil,
        fromPosition: Position? = nil,
        toPosition: Position? = nil,
        timestamp: Date = Date(),
        moveNumber: Int
    ) {
        self.id = id
        self.player = player
        self.type = type
        self.position = position
        self.fromPosition = fromPosition
        self.toPosition = toPosition
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
    
    /// 말 이동 생성
    public static func move(player: Player, from: Position, to: Position, moveNumber: Int) -> GameMove {
        return GameMove(
            player: player,
            type: .move,
            fromPosition: from,
            toPosition: to,
            moveNumber: moveNumber
        )
    }
} 
