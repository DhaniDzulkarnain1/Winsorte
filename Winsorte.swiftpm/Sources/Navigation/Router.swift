import SwiftUI

/// Manages app-wide navigation state
/// Uses NavigationStack with type-safe routing
@MainActor
final class Router: ObservableObject {

    // MARK: - Published Properties

    /// Navigation path for NavigationStack
    @Published var path = NavigationPath()

    // MARK: - Navigation Methods

    /// Navigate to a specific route
    func navigate(to route: AppRoute) {
        path.append(route)
    }

    /// Navigate back one screen
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// Navigate back to root (home screen)
    func navigateToRoot() {
        path = NavigationPath()
    }

    /// Navigate back n screens
    func navigateBack(count: Int) {
        guard count > 0 else { return }
        let removeCount = min(count, path.count)
        path.removeLast(removeCount)
    }

    /// Replace current screen with a new route
    func replace(with route: AppRoute) {
        if !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }

    // MARK: - Specific Navigation Helpers

    /// Navigate to algorithm selection
    func showAlgorithmSelection() {
        navigate(to: .algorithmSelection)
    }

    /// Navigate to learning mode for an algorithm
    func showLearning(for algorithm: Algorithm) {
        navigate(to: .learning(algorithm))
    }

    /// Navigate to game screen
    func startGame(algorithm: Algorithm, mode: GameMode) {
        navigate(to: .game(algorithm, mode: mode))
    }

    /// Navigate to result screen
    func showResult(with gameState: GameState) {
        navigate(to: .result(gameState))
    }

    /// Navigate back to home from result screen
    func backToHome() {
        navigateToRoot()
    }

    /// Navigate to next algorithm after completing current one
    func showNextAlgorithm() {
        // Pop to algorithm selection
        navigateToRoot()
        showAlgorithmSelection()
    }
}
