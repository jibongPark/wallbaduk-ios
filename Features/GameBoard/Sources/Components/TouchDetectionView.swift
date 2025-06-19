import SwiftUI
import GameDomain

public struct TouchDetectionView: View {
    let boardSize: BoardSize
    let cellSize: CGFloat
    let onPositionTapped: (GridPosition) -> Void
    
    public init(
        boardSize: BoardSize,
        cellSize: CGFloat,
        onPositionTapped: @escaping (GridPosition) -> Void
    ) {
        self.boardSize = boardSize
        self.cellSize = cellSize
        self.onPositionTapped = onPositionTapped
    }
    
    public var body: some View {
        let totalSize = cellSize * CGFloat(boardSize.gridSize)
        
        Rectangle()
            .fill(Color.clear)
            .frame(width: totalSize, height: totalSize)
            .contentShape(Rectangle())
            .onTapGesture { location in
                handleTap(at: location, totalSize: totalSize)
            }
    }
    
    private func handleTap(at location: CGPoint, totalSize: CGFloat) {
        let column = Int(location.x / cellSize)
        let row = Int(location.y / cellSize)
        
        // 유효한 위치인지 확인
        guard column >= 0 && column < boardSize.gridSize,
              row >= 0 && row < boardSize.gridSize else {
            return
        }
        
        let gridPosition = GridPosition(x: column, y: row)
        onPositionTapped(gridPosition)
    }
} 
