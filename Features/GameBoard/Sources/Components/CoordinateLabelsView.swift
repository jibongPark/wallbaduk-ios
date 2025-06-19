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
        let totalSize = cellSize * CGFloat(boardSize.gridSize)
        
        ZStack {
            // 상단 문자 좌표
            HStack(spacing: 0) {
                ForEach(0..<boardSize.gridSize, id: \.self) { column in
                    Text(columnLabel(for: column))
                        .font(.caption2)
                        .frame(width: cellSize, height: 20)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .position(x: totalSize / 2, y: -10)
            
            // 하단 문자 좌표
            HStack(spacing: 0) {
                ForEach(0..<boardSize.gridSize, id: \.self) { column in
                    Text(columnLabel(for: column))
                        .font(.caption2)
                        .frame(width: cellSize, height: 20)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .position(x: totalSize / 2, y: totalSize + 10)
            
            // 좌측 숫자 좌표
            VStack(spacing: 0) {
                ForEach(0..<boardSize.gridSize, id: \.self) { row in
                    Text("\(boardSize.gridSize - row)")
                        .font(.caption2)
                        .frame(width: 20, height: cellSize)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .position(x: -10, y: totalSize / 2)
            
            // 우측 숫자 좌표
            VStack(spacing: 0) {
                ForEach(0..<boardSize.gridSize, id: \.self) { row in
                    Text("\(boardSize.gridSize - row)")
                        .font(.caption2)
                        .frame(width: 20, height: cellSize)
                        .foregroundColor(AppColors.textSecondary)
                }
            }
            .position(x: totalSize + 10, y: totalSize / 2)
        }
    }
    
    private func columnLabel(for index: Int) -> String {
        let letter = Character(UnicodeScalar(65 + index)!)
        return String(letter)
    }
} 