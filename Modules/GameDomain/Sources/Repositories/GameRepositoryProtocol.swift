import Foundation
import RxSwift

public protocol GameRepositoryProtocol {
    /// 새 게임 생성
    func createGame(players: [Player], boardSize: BoardSize) -> Single<GameState>
    
    /// 게임 상태 조회
    func getGameState(gameId: UUID) -> Single<GameState>
    
    /// 게임 상태 저장
    func saveGameState(_ gameState: GameState) -> Single<Void>
    
    /// 게임 삭제
    func deleteGame(gameId: UUID) -> Single<Void>
    
    /// 모든 게임 목록 조회
    func getAllGames() -> Single<[GameState]>
    
    /// 진행 중인 게임 목록 조회
    func getActiveGames() -> Single<[GameState]>
    
    /// 완료된 게임 목록 조회
    func getCompletedGames() -> Single<[GameState]>
} 