import Foundation

public enum GameError: Error, LocalizedError {
    case invalidMove(String)
    case gameNotFound
    case saveError
    
    public var errorDescription: String? {
        switch self {
        case .invalidMove(let message):
            return "Invalid move: \(message)"
        case .gameNotFound:
            return "Game not found"
        case .saveError:
            return "Failed to save game"
        }
    }
} 