import SwiftUI
import GameDomain
import DesignSystem

public struct PieceView: View {
    let piece: GamePiece
    let cellSize: CGFloat
    let isSelected: Bool
    let onTapped: () -> Void
    
    @State private var isPressed = false
    
    public init(
        piece: GamePiece,
        cellSize: CGFloat,
        isSelected: Bool,
        onTapped: @escaping () -> Void
    ) {
        self.piece = piece
        self.cellSize = cellSize
        self.isSelected = isSelected
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Circle()
            .fill(playerColor)
            .frame(width: pieceSize, height: pieceSize)
            .overlay(
                // 선택된 말 표시
                Circle()
                    .stroke(AppColors.highlight, lineWidth: 3)
                    .opacity(isSelected ? 1.0 : 0.0)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
            )
            .overlay(
                // 말의 테두리
                Circle()
                    .stroke(strokeColor, lineWidth: 2)
            )
            .position(
                x: CGFloat(piece.position.x) * cellSize + cellSize / 2,
                y: CGFloat(piece.position.y) * cellSize + cellSize / 2
            )
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
            .onTapGesture {
                onTapped()
            }
            .onLongPressGesture(minimumDuration: 0) { isPressed in
                self.isPressed = isPressed
            } perform: {
                // 롱프레스 액션
            }
            .shadow(
                color: .black.opacity(0.3),
                radius: 2,
                x: 1,
                y: 1
            )
    }
    
    private var playerColor: Color {
        // ownerID를 기반으로 색상 결정
        // 첫 번째 플레이어는 검은색, 두 번째 플레이어는 흰색
        let isBlackPiece = piece.ownerID.uuidString.hashValue % 2 == 0
        return isBlackPiece ? AppColors.player1 : AppColors.player2
    }
    
    private var strokeColor: Color {
        playerColor == AppColors.player2 ? AppColors.player1 : AppColors.surface
    }
    
    private var pieceSize: CGFloat {
        cellSize * 0.8
    }
    
    private var selectionStrokeColor: Color {
        playerColor == AppColors.player2 ? AppColors.player1 : AppColors.surface
    }
} 