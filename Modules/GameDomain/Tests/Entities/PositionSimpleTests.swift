import XCTest
@testable import GameDomain

final class PositionSimpleTests: XCTestCase {
    
    func testPositionInitialization() {
        // Given & When
        let position = Position(row: 3, column: 5)
        
        // Then
        XCTAssertEqual(position.row, 3)
        XCTAssertEqual(position.column, 5)
    }
    
    func testPositionToGridPosition() {
        // Given
        let position = Position(row: 2, column: 4)
        
        // When
        let gridPosition = position.toGridPosition()
        
        // Then
        XCTAssertEqual(gridPosition.x, 4) // column -> x
        XCTAssertEqual(gridPosition.y, 2) // row -> y
    }
    
    func testPositionEquality() {
        // Given
        let position1 = Position(row: 1, column: 2)
        let position2 = Position(row: 1, column: 2)
        let position3 = Position(row: 2, column: 1)
        
        // When & Then
        XCTAssertEqual(position1, position2)
        XCTAssertNotEqual(position1, position3)
    }
    
    func testGridPositionInitialization() {
        // Given & When
        let gridPosition = GridPosition(x: 3, y: 4)
        
        // Then
        XCTAssertEqual(gridPosition.x, 3)
        XCTAssertEqual(gridPosition.y, 4)
    }
    
    func testGridPositionEquality() {
        // Given
        let gridPos1 = GridPosition(x: 2, y: 3)
        let gridPos2 = GridPosition(x: 2, y: 3)
        let gridPos3 = GridPosition(x: 3, y: 2)
        
        // When & Then
        XCTAssertEqual(gridPos1, gridPos2)
        XCTAssertNotEqual(gridPos1, gridPos3)
    }
} 