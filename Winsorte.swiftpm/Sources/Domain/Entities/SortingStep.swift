import Foundation

/// Represents a single step in a sorting algorithm
struct SortingStep: Equatable, Identifiable {
    let id: UUID

    /// Indices of elements being compared
    let compareIndices: (Int, Int)

    /// Whether the elements should be swapped
    let shouldSwap: Bool

    /// The resulting array after this step is executed
    let resultArray: [Int]

    /// Description of what happens in this step
    let description: String

    /// Optional: Indices that become sorted after this step
    let newlySortedIndices: Set<Int>?

    // MARK: - Initialization

    init(
        compareIndices: (Int, Int),
        shouldSwap: Bool,
        resultArray: [Int],
        description: String = "",
        newlySortedIndices: Set<Int>? = nil
    ) {
        self.id = UUID()
        self.compareIndices = compareIndices
        self.shouldSwap = shouldSwap
        self.resultArray = resultArray
        self.description = description
        self.newlySortedIndices = newlySortedIndices
    }

    // MARK: - Computed Properties

    /// Human-readable question for the user
    var questionText: String {
        let (i, j) = compareIndices
        let leftValue = resultArray[i]
        let rightValue = resultArray[j]

        return "Is \(leftValue) > \(rightValue)? Should you swap?"
    }

    /// Explanation of the correct answer
    var explanationText: String {
        let (i, j) = compareIndices
        let leftValue = resultArray[i]
        let rightValue = resultArray[j]

        if shouldSwap {
            return "\(leftValue) is greater than \(rightValue), so we swap them."
        } else {
            return "\(leftValue) is not greater than \(rightValue), so we keep them as is."
        }
    }
}

// MARK: - Equatable Conformance

extension SortingStep {
    static func == (lhs: SortingStep, rhs: SortingStep) -> Bool {
        lhs.id == rhs.id &&
        lhs.compareIndices.0 == rhs.compareIndices.0 &&
        lhs.compareIndices.1 == rhs.compareIndices.1 &&
        lhs.shouldSwap == rhs.shouldSwap &&
        lhs.resultArray == rhs.resultArray
    }
}
