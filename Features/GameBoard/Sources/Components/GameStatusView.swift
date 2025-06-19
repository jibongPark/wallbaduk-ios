import SwiftUI
import GameDomain
import DesignSystem

public struct GameStatusView: View {
    let gameState: GameState
    let onNewGame: () -> Void
    let onUndo: () -> Void
    let onRedo: () -> Void
    
    @State private var showingNewGameAlert = false
    
    public init(
        gameState: GameState,
        onNewGame: @escaping () -> Void,
        onUndo: @escaping () -> Void,
        onRedo: @escaping () -> Void
    ) {
        self.gameState = gameState
        self.onNewGame = onNewGame
        self.onUndo = onUndo
        self.onRedo = onRedo
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // 현재 플레이어 정보
            CurrentPlayerView(gameState: gameState)
            
            // 게임 통계
            GameStatsView(gameState: gameState)
            
            // 게임 컨트롤 버튼들
            HStack(spacing: 12) {
                // 새 게임 버튼
                Button(action: {
                    showingNewGameAlert = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("새 게임")
                    }
                    .font(.body.weight(.semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(AppColors.primary)
                    .cornerRadius(8)
                }
                
                // 실행취소 버튼
                Button(action: onUndo) {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .font(.title2)
                        .foregroundColor(canUndo ? AppColors.primary : AppColors.textSecondary)
                }
                .disabled(!canUndo)
                
                // 다시실행 버튼
                Button(action: onRedo) {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .font(.title2)
                        .foregroundColor(canRedo ? AppColors.primary : AppColors.textSecondary)
                }
                .disabled(!canRedo)
                
                Spacer()
            }
        }
        .padding()
        .background(AppColors.surface)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .alert("새 게임 시작", isPresented: $showingNewGameAlert) {
            Button("취소", role: .cancel) { }
            Button("확인", role: .destructive) {
                onNewGame()
            }
        } message: {
            Text("현재 게임을 종료하고 새 게임을 시작하시겠습니까?")
        }
    }
    
    private var canUndo: Bool {
        !gameState.moves.isEmpty
    }
    
    private var canRedo: Bool {
        // TODO: Implement redo history when available
        false
    }
}

// MARK: - 현재 플레이어 표시 뷰
private struct CurrentPlayerView: View {
    let gameState: GameState
    
    var body: some View {
        HStack {
            Text("현재 차례:")
                .font(.headline)
                .foregroundColor(AppColors.text)
            
            if let currentPlayer = gameState.currentPlayer {
                HStack {
                    Circle()
                        .fill(playerColor(for: currentPlayer))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(
                                    playerColor(for: currentPlayer) == AppColors.player2 ? 
                                    AppColors.player1 : AppColors.surface,
                                    lineWidth: 2
                                )
                        )
                    
                    Text(playerName(for: currentPlayer))
                        .font(.headline.weight(.semibold))
                        .foregroundColor(AppColors.text)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.background)
                .cornerRadius(16)
            } else {
                Text("게임 종료")
                    .font(.headline.weight(.semibold))
                    .foregroundColor(AppColors.textSecondary)
            }
            
            Spacer()
        }
    }
    
    private func playerColor(for player: Player) -> Color {
        player.isAI ? AppColors.player2 : AppColors.player1
    }
    
    private func playerName(for player: Player) -> String {
        player.isAI ? "AI" : "플레이어"
    }
}

// MARK: - 게임 통계 뷰
private struct GameStatsView: View {
    let gameState: GameState
    
    var body: some View {
        HStack {
            StatItem(
                title: "총 수",
                value: "\(gameState.moves.count)"
            )
            
            Spacer()
            
            StatItem(
                title: "말 개수",
                value: "\(activePiecesCount)"
            )
            
            Spacer()
            
            StatItem(
                title: "벽 개수",
                value: "\(gameState.gameBoard.walls.count)"
            )
        }
    }
    
    private var activePiecesCount: Int {
        gameState.gameBoard.pieces.filter { $0.isActive }.count
    }
}

// MARK: - 통계 항목 뷰
private struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2.weight(.bold))
                .foregroundColor(AppColors.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
        }
    }
} 