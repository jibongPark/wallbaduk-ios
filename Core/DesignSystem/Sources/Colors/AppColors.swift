import SwiftUI

public struct AppColors {
    
    // MARK: - Primary Colors
    public static let primary = Color("PrimaryBlue", bundle: .module)
    public static let secondary = Color("SecondaryGreen", bundle: .module)
    
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
    public static let background = Color("Background", bundle: .module)
    public static let surface = Color("Surface", bundle: .module)
    public static let text = Color("Text", bundle: .module)
    public static let textSecondary = Color("TextSecondary", bundle: .module)
}

// MARK: - Dynamic Color Support
extension Color {
    init(_ name: String, bundle: Bundle) {
        self.init(name, bundle: bundle)
    }
} 