import SwiftUI
import GameDomain
import DesignSystem

public struct GridLinesView: View {
    let boardSize: BoardSize
    let cellSize: CGFloat
    
    public init(boardSize: BoardSize, cellSize: CGFloat) {
        self.boardSize = boardSize
        self.cellSize = cellSize
    }
    
    public var body: some View {
        let totalSize = cellSize * CGFloat(boardSize.gridSize)
        
        ZStack {
            // 수직 라인들
            ForEach(0...boardSize.gridSize, id: \.self) { column in
                Rectangle()
                    .fill(AppColors.gridLine)
                    .frame(width: 1, height: totalSize)
                    .position(
                        x: CGFloat(column) * cellSize,
                        y: totalSize / 2
                    )
            }
            
            // 수평 라인들
            ForEach(0...boardSize.gridSize, id: \.self) { row in
                Rectangle()
                    .fill(AppColors.gridLine)
                    .frame(width: totalSize, height: 1)
                    .position(
                        x: totalSize / 2,
                        y: CGFloat(row) * cellSize
                    )
            }
            
            // 모서리 강조 라인
            Rectangle()
                .stroke(AppColors.gridLine.opacity(1.0), lineWidth: 2)
                .frame(width: totalSize, height: totalSize)
                .position(x: totalSize / 2, y: totalSize / 2)
        }
    }
} 