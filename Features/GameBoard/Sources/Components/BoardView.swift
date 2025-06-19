import SwiftUI
import GameDomain
import DesignSystem

public struct BoardView: View {
    @State private var selectedPosition: Position?
    @State private var highlightedPositions: [Position] = []
    
    let gameState: GameState
    let boardSize: BoardSize
    let onPieceTapped: (Position) -> Void
    let onPositionTapped: (Position) -> Void
    
    public init(
        gameState: GameState,
        boardSize: BoardSize,
        onPieceTapped: @escaping (Position) -> Void,
        onPositionTapped: @escaping (Position) -> Void
    ) {
        self.gameState = gameState
        self.boardSize = boardSize
        self.onPieceTapped = onPieceTapped
        self.onPositionTapped = onPositionTapped
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let cellSize = min(geometry.size.width, geometry.size.height) / CGFloat(boardSize.gridSize)
            
            ZStack {
                // 바둑판 배경
                Rectangle()
                    .fill(AppColors.boardBackground)
                    .frame(
                        width: cellSize * CGFloat(boardSize.gridSize),
                        height: cellSize * CGFloat(boardSize.gridSize)
                    )
                
                // 격자 라인
                GridLinesView(
                    boardSize: boardSize,
                    cellSize: cellSize
                )
                
                // 좌표 라벨
                CoordinateLabelsView(
                    boardSize: boardSize,
                    cellSize: cellSize
                )
                
                // 하이라이트된 위치들
                ForEach(highlightedPositions, id: \.self) { position in
                    HighlightView(position: position, cellSize: cellSize)
                }
                
                // 게임 말들
                ForEach(gameState.board.pieces, id: \.id) { piece in
                    if piece.isActive {
                        PieceView(
                            piece: piece,
                            cellSize: cellSize,
                            isSelected: selectedPosition?.gridPosition == piece.position,
                            onTapped: {
                                selectedPosition = Position(gridPosition: piece.position)
                                onPieceTapped(Position(gridPosition: piece.position))
                            }
                        )
                    }
                }
                
                // 벽들
                ForEach(gameState.walls, id: \.id) { wall in
                    WallView(
                        wall: wall,
                        cellSize: cellSize
                    )
                }
                
                // 터치 감지 영역
                TouchDetectionView(
                    boardSize: boardSize,
                    cellSize: cellSize,
                    onPositionTapped: { gridPosition in
                        onPositionTapped(Position(gridPosition: gridPosition))
                    }
                )
            }
        }
        .aspectRatio(1.0, contentMode: .fit)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedPosition)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: highlightedPositions)
    }
} 