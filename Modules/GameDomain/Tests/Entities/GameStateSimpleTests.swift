import XCTest
@testable import GameDomain

final class GameStateSimpleTests: XCTestCase {
    
    var gameState: GameState!
    var players: [Player]!
    let boardSize = BoardSize.medium
    
    override func setUp() {
        super.setUp()
        
        players = [
            Player(
                id: UUID(),
                name: "Player 1",
                color: .black,
                isAI: false
            ),
            Player(
                id: UUID(),
                name: "Player 2",
                color: .white,
                isAI: false
            )
        ]
        
        let board = GameBoard(size: boardSize)
        gameState = GameState(
            boardSize: boardSize,
            players: players,
            board: board
        )
    }
    
    override func tearDown() {
        gameState = nil
        players = nil
        super.tearDown()
    }
    
    func testGameStateInitialization() {
        // When & Then
        XCTAssertEqual(gameState.players.count, 2)
        XCTAssertEqual(gameState.currentPlayerIndex, 0)
        XCTAssertEqual(gameState.boardSize, boardSize)
        XCTAssertEqual(gameState.turnCount, 0)
        XCTAssertEqual(gameState.gamePhase, .playing)
        XCTAssertTrue(gameState.moves.isEmpty)
        XCTAssertTrue(gameState.walls.isEmpty)
    }
    
    func testCurrentPlayer() {
        // When & Then
        XCTAssertNotNil(gameState.currentPlayer)
        XCTAssertEqual(gameState.currentPlayer?.id, players[0].id)
        XCTAssertEqual(gameState.currentPlayer?.name, "Player 1")
    }
    
    func testNextTurn() {
        // When
        let newGameState = gameState.nextTurn()
        
        // Then
        XCTAssertEqual(newGameState.currentPlayerIndex, 1)
        XCTAssertEqual(newGameState.turnCount, 1)
        XCTAssertGreaterThan(newGameState.updatedAt, gameState.updatedAt)
        
        // 원본은 변경되지 않음
        XCTAssertEqual(gameState.currentPlayerIndex, 0)
        XCTAssertEqual(gameState.turnCount, 0)
    }
    
    func testIsGameFinished() {
        // Given - 게임이 진행 중일 때
        XCTAssertEqual(gameState.gamePhase, .playing)
        XCTAssertFalse(gameState.isGameFinished)
        
        // When - 게임이 종료되었을 때
        let finishedGameState = GameState(
            boardSize: boardSize,
            players: players,
            board: GameBoard(size: boardSize),
            gamePhase: .finished
        )
        
        // Then
        XCTAssertTrue(finishedGameState.isGameFinished)
    }
} 