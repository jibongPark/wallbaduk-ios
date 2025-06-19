import SwiftUI
import GameDomain
import DesignSystem

public struct WallView: View {
    let wall: Wall
    let cellSize: CGFloat
    
    @State private var isAppearing = false
    
    public init(wall: Wall, cellSize: CGFloat) {
        self.wall = wall
        self.cellSize = cellSize
    }
    
    public var body: some View {
        Rectangle()
            .fill(wallColor)
            .frame(width: wallWidth, height: wallHeight)
            .position(wallPosition)
            .scaleEffect(isAppearing ? 1.0 : 0.1)
            .opacity(isAppearing ? 1.0 : 0.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isAppearing)
            .shadow(
                color: .black.opacity(0.4),
                radius: 3,
                x: 2,
                y: 2
            )
            .onAppear {
                isAppearing = true
            }
    }
    
    private var wallColor: Color {
        AppColors.text.opacity(0.8)
    }
    
    private var wallWidth: CGFloat {
        switch wall.orientation {
        case .horizontal:
            return cellSize * 0.9
        case .vertical:
            return cellSize * 0.15
        }
    }
    
    private var wallHeight: CGFloat {
        switch wall.orientation {
        case .horizontal:
            return cellSize * 0.15
        case .vertical:
            return cellSize * 0.9
        }
    }
    
    private var wallPosition: CGPoint {
        let gridPos = wall.position
        let baseX = CGFloat(gridPos.x) * cellSize + cellSize / 2
        let baseY = CGFloat(gridPos.y) * cellSize + cellSize / 2
        
        switch wall.orientation {
        case .horizontal:
            // 수평 벽: 위치 아래쪽 격자선
            return CGPoint(x: baseX, y: baseY + cellSize / 2)
        case .vertical:
            // 수직 벽: 위치 오른쪽 격자선
            return CGPoint(x: baseX + cellSize / 2, y: baseY)
        }
    }
} 