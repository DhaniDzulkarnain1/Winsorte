import Foundation

/// Difficulty level of a sorting algorithm
enum Difficulty: String, CaseIterable {
    case easy
    case medium
    case hard

    // MARK: - Display Properties

    /// Number of stars representing difficulty (1-3)
    var stars: Int {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 2
        case .hard:
            return 3
        }
    }

    /// Star emoji representation for UI
    var starDisplay: String {
        String(repeating: "⭐", count: stars)
    }

    /// Human-readable difficulty label
    var displayName: String {
        switch self {
        case .easy:
            return "Easy"
        case .medium:
            return "Medium"
        case .hard:
            return "Hard"
        }
    }

    /// Description of what this difficulty means
    var description: String {
        switch self {
        case .easy:
            return "Perfect for beginners. Simple concepts and fewer steps."
        case .medium:
            return "Intermediate level. More complex logic and patterns."
        case .hard:
            return "Advanced challenge. Complex algorithm with multiple decision points."
        }
    }
}
