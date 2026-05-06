import Foundation

/// Represents the current state of an active sorting game
struct GameState: Equatable {
    // MARK: - Array State

    /// Current array being sorted
    var array: [Int]

    /// Original unsorted array (for reference)
    let originalArray: [Int]

    /// Indices that are currently being compared
    var compareIndices: (Int, Int)?

    /// Indices that have been sorted and placed in final position
    var sortedIndices: Set<Int>

    // MARK: - Algorithm State

    /// The algorithm being used
    let algorithm: AlgorithmType

    /// Current step in the sorting process
    var currentStep: Int

    /// Total number of steps required to sort
    var totalSteps: Int

    // MARK: - Game Metrics

    /// Number of consecutive correct answers
    var streak: Int

    /// Total number of errors made
    var errors: Int

    /// Number of correct swaps/comparisons
    var correctMoves: Int

    /// Time when game started
    let startTime: Date

    /// Time when game ended (nil if still in progress)
    var endTime: Date?

    // MARK: - Status

    /// Whether the sorting is complete
    var isComplete: Bool

    /// Whether the game is paused
    var isPaused: Bool

    // MARK: - Initialization

    init(
        array: [Int],
        algorithm: AlgorithmType,
        totalSteps: Int = 0
    ) {
        self.array = array
        self.originalArray = array
        self.algorithm = algorithm
        self.compareIndices = nil
        self.sortedIndices = []
        self.currentStep = 0
        self.totalSteps = totalSteps
        self.streak = 0
        self.errors = 0
        self.correctMoves = 0
        self.startTime = Date()
        self.endTime = nil
        self.isComplete = false
        self.isPaused = false
    }

    // MARK: - Computed Properties

    /// Returns true if the array is sorted
    var isSorted: Bool {
        for i in 0..<(array.count - 1) {
            if array[i] > array[i + 1] {
                return false
            }
        }
        return true
    }

    /// Total time elapsed (in seconds)
    var elapsedTime: TimeInterval {
        let end = endTime ?? Date()
        return end.timeIntervalSince(startTime)
    }

    /// Accuracy percentage (0-100)
    var accuracy: Double {
        let totalAttempts = correctMoves + errors
        guard totalAttempts > 0 else { return 100.0 }
        return (Double(correctMoves) / Double(totalAttempts)) * 100.0
    }

    /// Star rating (1-3 based on performance)
    var starRating: Int {
        if errors == 0 {
            return 3  // Perfect
        } else if errors <= 2 {
            return 2  // Good
        } else {
            return 1  // Completed
        }
    }

    // MARK: - Mutating Methods

    /// Marks the game as complete
    mutating func complete() {
        isComplete = true
        endTime = Date()
    }

    /// Records a correct move
    mutating func recordCorrectMove() {
        correctMoves += 1
        streak += 1
    }

    /// Records an error
    mutating func recordError() {
        errors += 1
        streak = 0
    }

    /// Updates the comparison indices
    mutating func updateCompareIndices(_ indices: (Int, Int)?) {
        compareIndices = indices
    }

    /// Marks an index as sorted
    mutating func markAsSorted(_ index: Int) {
        sortedIndices.insert(index)
    }

    /// Swaps two elements in the array
    mutating func swap(at index1: Int, with index2: Int) {
        guard index1 >= 0, index1 < array.count,
              index2 >= 0, index2 < array.count else {
            return
        }
        array.swapAt(index1, index2)
    }

    /// Advances to the next step
    mutating func nextStep() {
        currentStep += 1
    }
}

// MARK: - Equatable Conformance

extension GameState {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        // Compare optional tuples manually
        let compareIndicesEqual: Bool
        switch (lhs.compareIndices, rhs.compareIndices) {
        case (nil, nil):
            compareIndicesEqual = true
        case let (l?, r?):
            compareIndicesEqual = l.0 == r.0 && l.1 == r.1
        default:
            compareIndicesEqual = false
        }

        return lhs.array == rhs.array &&
               lhs.originalArray == rhs.originalArray &&
               compareIndicesEqual &&
               lhs.sortedIndices == rhs.sortedIndices &&
               lhs.algorithm == rhs.algorithm &&
               lhs.currentStep == rhs.currentStep &&
               lhs.totalSteps == rhs.totalSteps &&
               lhs.streak == rhs.streak &&
               lhs.errors == rhs.errors &&
               lhs.correctMoves == rhs.correctMoves &&
               lhs.isComplete == rhs.isComplete &&
               lhs.isPaused == rhs.isPaused
    }
}
