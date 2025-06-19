// MARK: - GameBoard Module Exports

// Re-export dependencies
@_exported import GameDomain
@_exported import DesignSystem

// Public exports - All RIB components are now in separate files:
// - GameBoardBuilder.swift
// - GameBoardInteractor.swift  
// - GameBoardRouter.swift
// - GameBoardViewController.swift
// - GameComponent+GameSettings.swift

// UI Components are already public in their respective files:
// - BoardView, PieceView, WallView, GameStatusView, GridLinesView, 
// - HighlightView, CoordinateLabelsView, TouchDetectionView 