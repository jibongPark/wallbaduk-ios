import XCTest
@testable import GameDomain

final class GameIntegrationTests: XCTestCase {
    
    var gameState: GameState!
    var players: [Player]!
    
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
        
        let board = GameBoard(size: .medium)
        gameState = GameState(
            boardSize: .medium,
            players: players,
            board: board
        )
    }
    
    override func tearDown() {
        gameState = nil
        players = nil
        super.tearDown()
    }
    
    func testGamePieceLifecycle() {
        // Given
        let position = Position(row: 2, column: 2)
        let piece = GamePiece(ownerID: players[0].id, position: position.toGridPosition())
        
        // When - 말 배치
        gameState.board.placePiece(piece, at: position)
        
        // Then - 말이 배치됨
        XCTAssertTrue(gameState.board.hasPiece(at: position))
        XCTAssertEqual(gameState.board.pieces.count, 1)
        
        // When - 말 제거
        let removedPiece = gameState.board.removePiece(at: position)
        
        // Then - 말이 제거됨
        XCTAssertNotNil(removedPiece)
        XCTAssertFalse(gameState.board.hasPiece(at: position))
        XCTAssertEqual(gameState.board.pieces.count, 0)
    }
    
    func testGameTurnManagement() {
        // Given
        let initialTurnCount = gameState.turnCount
        let initialPlayerIndex = gameState.currentPlayerIndex
        
        // When - 턴 진행
        let newGameState1 = gameState.nextTurn()
        let newGameState2 = newGameState1.nextTurn()
        
        // Then - 턴이 올바르게 진행됨
        XCTAssertEqual(newGameState1.currentPlayerIndex, 1)
        XCTAssertEqual(newGameState1.turnCount, initialTurnCount + 1)
        
        XCTAssertEqual(newGameState2.currentPlayerIndex, 0) // 순환
        XCTAssertEqual(newGameState2.turnCount, initialTurnCount + 2)
        
        // 원본은 변경되지 않음
        XCTAssertEqual(gameState.currentPlayerIndex, initialPlayerIndex)
        XCTAssertEqual(gameState.turnCount, initialTurnCount)
    }
    
    func testGamePieceInteraction() {
        // Given
        let position1 = Position(row: 1, column: 1)
        let position2 = Position(row: 2, column: 2)
        let position3 = Position(row: 1, column: 1) // 같은 위치
        
        let piece1 = GamePiece(ownerID: players[0].id, position: position1.toGridPosition())
        let piece2 = GamePiece(ownerID: players[1].id, position: position2.toGridPosition())
        let piece3 = GamePiece(ownerID: players[0].id, position: position3.toGridPosition())
        
        // When - 첫 번째 말 배치
        gameState.board.placePiece(piece1, at: position1)
        XCTAssertTrue(gameState.board.hasPiece(at: position1))
        
        // When - 두 번째 말 배치 (다른 위치)
        gameState.board.placePiece(piece2, at: position2)
        XCTAssertTrue(gameState.board.hasPiece(at: position2))
        XCTAssertEqual(gameState.board.pieces.count, 2)
        
        // When - 세 번째 말 배치 (같은 위치)
        gameState.board.placePiece(piece3, at: position3)
        
        // Then - 세 번째 말이 추가됨 (배열에 추가되지만 실제 게임에서는 규칙으로 막아야 함)
        XCTAssertEqual(gameState.board.pieces.count, 3)
    }
    
    func testPositionConversion() {
        // Given
        let position = Position(row: 3, column: 4)
        let gridPosition = GridPosition(x: 4, y: 3)
        
        // When & Then
        XCTAssertEqual(position.toGridPosition(), gridPosition)
        XCTAssertEqual(position.gridPosition, gridPosition)
    }
    
    func testGameStateImmutability() {
        // Given
        let originalId = gameState.id
        let originalPlayerCount = gameState.players.count
        let originalBoardSize = gameState.boardSize
        
        // When - 턴 진행
        let newGameState = gameState.nextTurn()
        
        // Then - 기본 속성은 유지됨
        XCTAssertEqual(newGameState.id, originalId)
        XCTAssertEqual(newGameState.players.count, originalPlayerCount)
        XCTAssertEqual(newGameState.boardSize, originalBoardSize)
        
        // 변경되는 속성만 다름
        XCTAssertNotEqual(newGameState.currentPlayerIndex, gameState.currentPlayerIndex)
        XCTAssertNotEqual(newGameState.turnCount, gameState.turnCount)
        XCTAssertNotEqual(newGameState.updatedAt, gameState.updatedAt)
    }
    
    func testGameBoardValidation() {
        // Given
        let boardSize = gameState.board.size
        
        // Valid positions
        let validPositions = [
            Position(row: 0, column: 0),
            Position(row: boardSize.gridSize - 1, column: boardSize.gridSize - 1),
            Position(row: boardSize.gridSize / 2, column: boardSize.gridSize / 2)
        ]
        
        // Invalid positions
        let invalidPositions = [
            Position(row: -1, column: 0),
            Position(row: 0, column: -1),
            Position(row: boardSize.gridSize, column: 0),
            Position(row: 0, column: boardSize.gridSize)
        ]
        
        // When & Then
        for position in validPositions {
            XCTAssertTrue(gameState.board.isValidPosition(position), "Position \(position) should be valid")
        }
        
        for position in invalidPositions {
            XCTAssertFalse(gameState.board.isValidPosition(position), "Position \(position) should be invalid")
        }
    }
} 