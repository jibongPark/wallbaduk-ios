import XCTest
@testable import GameDomain

final class GameBoardSimpleTests: XCTestCase {
    
    var gameBoard: GameBoard!
    let boardSize = BoardSize.medium
    let testPlayerID = UUID()
    
    override func setUp() {
        super.setUp()
        gameBoard = GameBoard(size: boardSize)
    }
    
    override func tearDown() {
        gameBoard = nil
        super.tearDown()
    }
    
    // MARK: - 기본 테스트
    
    func testGameBoardInitialization() {
        // When & Then
        XCTAssertEqual(gameBoard.size, boardSize)
        XCTAssertEqual(gameBoard.pieces.count, 0)
        XCTAssertFalse(gameBoard.grid.isEmpty)
    }
    
    func testPlacePieceAtPosition() {
        // Given
        let position = Position(row: 1, column: 1)
        let piece = GamePiece(ownerID: testPlayerID, position: position.toGridPosition())
        
        // When
        gameBoard.placePiece(piece, at: position)
        
        // Then
        XCTAssertNotNil(gameBoard.getPiece(at: position))
        XCTAssertEqual(gameBoard.pieces.count, 1)
        XCTAssertTrue(gameBoard.hasPiece(at: position))
        XCTAssertFalse(gameBoard.isEmpty(at: position))
    }
    
    func testRemovePieceAtPosition() {
        // Given
        let position = Position(row: 2, column: 2)
        let piece = GamePiece(ownerID: testPlayerID, position: position.toGridPosition())
        gameBoard.placePiece(piece, at: position)
        
        // When
        let removedPiece = gameBoard.removePiece(at: position)
        
        // Then
        XCTAssertNotNil(removedPiece)
        XCTAssertEqual(removedPiece?.id, piece.id)
        XCTAssertNil(gameBoard.getPiece(at: position))
        XCTAssertFalse(gameBoard.hasPiece(at: position))
        XCTAssertTrue(gameBoard.isEmpty(at: position))
    }
    
    func testIsValidPosition() {
        // Valid positions
        XCTAssertTrue(gameBoard.isValidPosition(Position(row: 0, column: 0)))
        XCTAssertTrue(gameBoard.isValidPosition(Position(row: boardSize.gridSize - 1, column: boardSize.gridSize - 1)))
        
        // Invalid positions
        XCTAssertFalse(gameBoard.isValidPosition(Position(row: -1, column: 0)))
        XCTAssertFalse(gameBoard.isValidPosition(Position(row: 0, column: -1)))
        XCTAssertFalse(gameBoard.isValidPosition(Position(row: boardSize.gridSize, column: 0)))
        XCTAssertFalse(gameBoard.isValidPosition(Position(row: 0, column: boardSize.gridSize)))
    }
} 