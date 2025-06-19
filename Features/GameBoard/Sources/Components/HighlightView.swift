import SwiftUI
import GameDomain
import DesignSystem

public struct HighlightView: View {
    let position: Position
    let cellSize: CGFloat
    
    @State private var animationScale: CGFloat = 0.8
    @State private var animationOpacity: Double = 0.6
    
    public init(position: Position, cellSize: CGFloat) {
        self.position = position
        self.cellSize = cellSize
    }
    
    public var body: some View {
        Circle()
            .fill(AppColors.highlight)
            .frame(width: highlightSize, height: highlightSize)
            .position(
                x: CGFloat(position.gridPosition.x) * cellSize + cellSize / 2,
                y: CGFloat(position.gridPosition.y) * cellSize + cellSize / 2
            )
            .scaleEffect(animationScale)
            .opacity(animationOpacity)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.0)
                        .repeatForever(autoreverses: true)
                ) {
                    animationScale = 1.2
                    animationOpacity = 0.3
                }
            }
    }
    
    private var highlightSize: CGFloat {
        cellSize * 0.4
    }
} 