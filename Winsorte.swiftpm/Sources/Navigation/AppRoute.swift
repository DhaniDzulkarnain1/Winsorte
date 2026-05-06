import Foundation

/// Defines all possible navigation routes in the app
enum AppRoute: Identifiable {
    case home
    case algorithmSelection
    case learning(Algorithm)
    case game(Algorithm, mode: GameMode)
    case result(GameState)

    var id: String {
        switch self {
        case .home:
            return "home"
        case .algorithmSelection:
            return "algorithmSelection"
        case .learning(let algorithm):
            return "learning-\(algorithm.id)"
        case .game(let algorithm, let mode):
            return "game-\(algorithm.id)-\(mode.rawValue)"
        case .result:
            return "result-\(UUID().uuidString)"
        }
    }

    // MARK: - Display Properties

    /// Navigation title for the route
    var navigationTitle: String {
        switch self {
        case .home:
            return "Winsorte"
        case .algorithmSelection:
            return "Choose Algorithm"
        case .learning(let algorithm):
            return algorithm.name
        case .game(let algorithm, _):
            return algorithm.name
        case .result:
            return "Results"
        }
    }

    /// Whether the navigation bar should be hidden
    var hidesNavigationBar: Bool {
        switch self {
        case .home, .result:
            return true
        default:
            return false
        }
    }
}

// MARK: - Game Mode

/// Different modes of playing the game
enum GameMode: String, CaseIterable {
    case demo           // Watch auto-animation
    case practice       // Interactive with hints
    case challenge      // No hints, test mastery

    var displayName: String {
        switch self {
        case .demo:
            return "Watch Demo"
        case .practice:
            return "Try It Yourself"
        case .challenge:
            return "Challenge"
        }
    }

    var icon: String {
        switch self {
        case .demo:
            return "eye.fill"
        case .practice:
            return "gamecontroller.fill"
        case .challenge:
            return "trophy.fill"
        }
    }

    var description: String {
        switch self {
        case .demo:
            return "Watch the algorithm in action"
        case .practice:
            return "Interactive mode with helpful hints"
        case .challenge:
            return "Test your mastery without hints"
        }
    }
}

// MARK: - Hashable Conformance

extension AppRoute: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        lhs.id == rhs.id
    }
}
