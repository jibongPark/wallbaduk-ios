import SwiftUI
import GameDomain

public struct TouchDetectionView: View {
    let boardSize: BoardSize
    let cellSize: CGFloat
    let onPositionTapped: (Position) -> Void
    
    public init(
        boardSize: BoardSize,
        cellSize: CGFloat,
        onPositionTapped: @escaping (Position) -> Void
    ) {
        self.boardSize = boardSize
        self.cellSize = cellSize
        self.onPositionTapped = onPositionTapped
    }
    
    public var body: some View {
        let totalSize = cellSize * CGFloat(boardSize.gridCount)
        
        Rectangle()
            .fill(Color.clear)
            .frame(width: totalSize, height: totalSize)
            .contentShape(Rectangle())
            .onTapGesture { location in
                handleTap(at: location)
            }
    }
    
    private func handleTap(at location: CGPoint) {
        let column = Int(location.x / cellSize)
        let row = Int(location.y / cellSize)
        
        // 보드 경계 확인
        guard column >= 0 && column < boardSize.gridCount,
              row >= 0 && row < boardSize.gridCount else {
            return
        }
        
        let gridPosition = GridPosition(row: row, column: column)
        let position = Position(gridPosition: gridPosition)
        
        onPositionTapped(position)
    }
} 