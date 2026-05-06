import Foundation

/// Types of sorting algorithms available in the app
enum AlgorithmType: String, CaseIterable, Identifiable {
    case bubbleSort
    case selectionSort
    case insertionSort
    case quickSort

    var id: String { rawValue }

    // MARK: - Display Properties

    /// Human-readable name of the algorithm
    var displayName: String {
        switch self {
        case .bubbleSort:
            return "Bubble Sort"
        case .selectionSort:
            return "Selection Sort"
        case .insertionSort:
            return "Insertion Sort"
        case .quickSort:
            return "Quick Sort"
        }
    }

    /// SF Symbol icon name for the algorithm
    var iconName: String {
        switch self {
        case .bubbleSort:
            return "bubble.left.and.bubble.right.fill"
        case .selectionSort:
            return "hand.point.up.left.fill"
        case .insertionSort:
            return "square.stack.3d.up.fill"
        case .quickSort:
            return "bolt.fill"
        }
    }

    /// Brief description of how the algorithm works
    var description: String {
        switch self {
        case .bubbleSort:
            return "Compare adjacent elements and swap if needed. The largest values 'bubble' to the end."
        case .selectionSort:
            return "Find the minimum element and move it to the sorted portion, one at a time."
        case .insertionSort:
            return "Build the sorted array one element at a time by inserting into the correct position."
        case .quickSort:
            return "Divide and conquer: partition around a pivot and recursively sort."
        }
    }

    /// Full explanation for learning mode
    var explanation: String {
        switch self {
        case .bubbleSort:
            return """
            Bubble Sort works by repeatedly comparing adjacent elements in the array.

            If the left element is greater than the right element, they are swapped.

            After each complete pass, the largest element "bubbles up" to its correct position at the end.

            This process continues until no more swaps are needed, meaning the array is sorted.
            """
        case .selectionSort:
            return """
            Selection Sort divides the array into sorted and unsorted portions.

            In each step, it finds the minimum element from the unsorted portion.

            This minimum element is swapped with the first unsorted element.

            The sorted portion grows by one element each time until the entire array is sorted.
            """
        case .insertionSort:
            return """
            Insertion Sort builds the final sorted array one element at a time.

            It picks the next element and inserts it into its correct position in the sorted portion.

            Elements are shifted to make room for the inserted element.

            Like sorting playing cards in your hand, it's efficient for small or nearly-sorted arrays.
            """
        case .quickSort:
            return """
            Quick Sort is a divide-and-conquer algorithm.

            It picks a 'pivot' element and partitions the array around it.

            Elements smaller than the pivot go to the left, larger ones to the right.

            It then recursively sorts the left and right partitions.
            """
        }
    }
}
