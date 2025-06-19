import SwiftUI

public struct AppColors {
    
    // MARK: - Primary Colors
    public static let primary = Color(red: 0.0, green: 0.48, blue: 1.0) // Primary Blue
    public static let secondary = Color(red: 0.0, green: 0.8, blue: 0.4) // Secondary Green
    
    // MARK: - Player Colors
    public static let player1 = Color.black
    public static let player2 = Color.white
    public static let player3 = Color.blue
    public static let player4 = Color.green
    
    // MARK: - Game Board Colors
    public static let gridLine = Color.gray.opacity(0.3)
    public static let highlight = Color.yellow.opacity(0.6)
    public static let boardBackground = Color(red: 0.94, green: 0.87, blue: 0.69)
    
    // MARK: - UI Colors
    public static let background = Color(red: 0.98, green: 0.98, blue: 0.98) // Light background
    public static let surface = Color.white // Surface color
    public static let text = Color.primary // Primary text
    public static let textSecondary = Color.secondary // Secondary text
}
