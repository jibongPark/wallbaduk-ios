import XCTest
@testable import GameDomain

final class GamePieceSimpleTests: XCTestCase {
    
    var gamePiece: GamePiece!
    let testPlayerID = UUID()
    let testPosition = GridPosition(x: 2, y: 2)
    
    override func setUp() {
        super.setUp()
        gamePiece = GamePiece(
            ownerID: testPlayerID,
            position: testPosition
        )
    }
    
    override func tearDown() {
        gamePiece = nil
        super.tearDown()
    }
    
    func testGamePieceInitialization() {
        // When & Then
        XCTAssertEqual(gamePiece.ownerID, testPlayerID)
        XCTAssertEqual(gamePiece.position, testPosition)
        XCTAssertTrue(gamePiece.isActive)
        XCTAssertEqual(gamePiece.maxMoveDistance, 2)
    }
    
    func testGamePieceWithInactiveState() {
        // Given & When
        let inactivePiece = GamePiece(
            ownerID: testPlayerID,
            position: testPosition,
            isActive: false
        )
        
        // Then
        XCTAssertFalse(inactivePiece.isActive)
    }
    
    func testGamePieceMove() {
        // Given & When
        let newPosition = GridPosition(x: 3, y: 3)
        let movedPiece = GamePiece(
            id: gamePiece.id,
            ownerID: gamePiece.ownerID,
            position: newPosition,
            isActive: gamePiece.isActive,
            moveCount: gamePiece.moveCount + 1
        )
        
        // Then
        XCTAssertEqual(movedPiece.position, newPosition)
        XCTAssertEqual(movedPiece.moveCount, 1)
    }
    
    func testGamePieceEquality() {
        // Given
        let samePiece = GamePiece(
            id: gamePiece.id,
            ownerID: testPlayerID,
            position: testPosition
        )
        let differentPiece = GamePiece(
            ownerID: UUID(),
            position: GridPosition(x: 1, y: 1)
        )
        
        // When & Then
        XCTAssertEqual(gamePiece, samePiece)
        XCTAssertNotEqual(gamePiece, differentPiece)
    }
} 