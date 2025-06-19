import SwiftUI
import GameDomain
import DesignSystem

public struct CoordinateLabelsView: View {
    let boardSize: BoardSize
    let cellSize: CGFloat
    
    public init(boardSize: BoardSize, cellSize: CGFloat) {
        self.boardSize = boardSize
        self.cellSize = cellSize
    }
    
    public var body: some View {
        let totalSize = cellSize * CGFloat(boardSize.gridCount)
        
        ZStack {
            // 상단 열 라벨 (A, B, C, ...)
            ForEach(0..<boardSize.gridCount, id: \.self) { column in
                Text(columnLabel(for: column))
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textSecondary)
                    .position(
                        x: CGFloat(column) * cellSize + cellSize / 2,
                        y: -15
                    )
            }
            
            // 하단 열 라벨 (A, B, C, ...)
            ForEach(0..<boardSize.gridCount, id: \.self) { column in
                Text(columnLabel(for: column))
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textSecondary)
                    .position(
                        x: CGFloat(column) * cellSize + cellSize / 2,
                        y: totalSize + 15
                    )
            }
            
            // 좌측 행 라벨 (1, 2, 3, ...)
            ForEach(0..<boardSize.gridCount, id: \.self) { row in
                Text("\(boardSize.gridCount - row)")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textSecondary)
                    .position(
                        x: -15,
                        y: CGFloat(row) * cellSize + cellSize / 2
                    )
            }
            
            // 우측 행 라벨 (1, 2, 3, ...)
            ForEach(0..<boardSize.gridCount, id: \.self) { row in
                Text("\(boardSize.gridCount - row)")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textSecondary)
                    .position(
                        x: totalSize + 15,
                        y: CGFloat(row) * cellSize + cellSize / 2
                    )
            }
        }
    }
    
    private func columnLabel(for column: Int) -> String {
        let asciiValue = 65 + column // A = 65
        return String(Character(UnicodeScalar(asciiValue)!))
    }
} 