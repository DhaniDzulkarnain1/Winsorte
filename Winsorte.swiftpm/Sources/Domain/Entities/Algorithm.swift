import Foundation

/// Represents a sorting algorithm with its metadata and properties
struct Algorithm: Identifiable, Equatable {
    let id: String
    let type: AlgorithmType
    let difficulty: Difficulty
    var isUnlocked: Bool
    var isCompleted: Bool
    var bestScore: Int?

    // MARK: - Initialization

    init(
        type: AlgorithmType,
        difficulty: Difficulty,
        isUnlocked: Bool = false,
        isCompleted: Bool = false,
        bestScore: Int? = nil
    ) {
        self.id = type.rawValue
        self.type = type
        self.difficulty = difficulty
        self.isUnlocked = isUnlocked
        self.isCompleted = isCompleted
        self.bestScore = bestScore
    }

    // MARK: - Computed Properties

    /// Display name of the algorithm
    var name: String {
        type.displayName
    }

    /// SF Symbol icon name
    var iconName: String {
        type.iconName
    }

    /// Short description
    var description: String {
        type.description
    }

    /// Full explanation for learning
    var explanation: String {
        type.explanation
    }

    /// Number of stars for difficulty
    var difficultyStars: String {
        difficulty.starDisplay
    }

    // MARK: - Static Factory Methods

    /// Returns all available algorithms in the app
    static func allAlgorithms() -> [Algorithm] {
        [
            Algorithm(
                type: .bubbleSort,
                difficulty: .easy,
                isUnlocked: true  // Unlocked by default
            ),
            Algorithm(
                type: .selectionSort,
                difficulty: .easy,
                isUnlocked: false  // Locked initially
            ),
            Algorithm(
                type: .insertionSort,
                difficulty: .medium,
                isUnlocked: false
            ),
            Algorithm(
                type: .quickSort,
                difficulty: .hard,
                isUnlocked: false  // Bonus/advanced
            )
        ]
    }

    /// Returns the default unlocked algorithm (Bubble Sort)
    static func defaultAlgorithm() -> Algorithm {
        Algorithm(
            type: .bubbleSort,
            difficulty: .easy,
            isUnlocked: true
        )
    }
}

// MARK: - Hashable Conformance

extension Algorithm: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
