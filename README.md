# Winsorte

**Master Sorting, Win the Code**

An interactive educational game that transforms learning sorting algorithms from passive observation into active participation. Instead of just watching visualizations, users become the algorithm themselves, making real-time decisions about comparisons and swaps.

[![iOS](https://img.shields.io/badge/iOS-17.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-Latest-green.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview

Winsorte is an interactive iOS application designed to make computer science education more engaging and accessible. The app teaches sorting algorithms through hands-on gameplay where users actively execute each step of the sorting process.

### Key Features

- **Interactive Learning**: Users make decisions about comparisons and swaps in real-time
- **Multiple Algorithms**: Bubble Sort, Selection Sort, Insertion Sort, and Quick Sort
- **Visual Feedback**: Instant validation with animations, colors, and haptic feedback
- **Progressive Difficulty**: Unlock new algorithms as you master previous ones
- **Gamification**: Streaks, stars, and performance tracking
- **Full Accessibility**: WCAG AAA compliance with VoiceOver, Dynamic Type, and Reduce Motion support

---

## Screenshots

| Home Screen | Algorithm Selection | Interactive Gameplay | Completion |
|------------|-------------------|---------------------|-----------|
| *Coming soon* | *Coming soon* | *Coming soon* | *Coming soon* |

---

## Technical Highlights

### Architecture
- **Pattern**: MVVM + Clean Architecture with feature-first organization
- **State Management**: SwiftUI native (`@StateObject`, `@Published`, `@EnvironmentObject`)
- **Dependencies**: Zero external dependencies - pure Swift/SwiftUI

### Design System
- **Modern iOS**: Liquid Glass materials for controls following HIG 2026
- **Pixel Art Content**: Retro-style visual elements for educational content
- **Dynamic Theming**: Full light/dark mode support with automatic adaptation
- **Accessibility First**:
  - WCAG AAA contrast ratios (14.2:1 light, 12.1:1 dark)
  - Dynamic Type support up to 310% scaling
  - VoiceOver labels and hints on all interactive elements
  - Reduce Motion implementation with graceful degradation
  - Touch targets exceeding 44pt minimum

### Human Interface Guidelines Compliance
Winsorte fully adheres to Apple's HIG 2026:
- ✅ Dynamic Color System (light/dark modes)
- ✅ Liquid Glass Materials (controls layer)
- ✅ Safe Area Respect
- ✅ Accessibility (Vision, Hearing, Mobility, Cognitive)
- ✅ Platform Conventions

For detailed compliance information, see [HIG_2026_COMPLIANCE_SUMMARY.md](HIG_2026_COMPLIANCE_SUMMARY.md)

---

## Getting Started

### Requirements
- iOS 17.0+ / iPadOS 17.0+
- Xcode 15.0+ or Swift Playgrounds
- Swift 5.9+

### Installation

#### Option 1: Swift Playgrounds (Recommended for Learning)
1. Download the `Winsorte.swiftpm` folder
2. Open in Swift Playgrounds app on iPad or Mac
3. Tap "Run My Code" to start

#### Option 2: Xcode
1. Clone this repository:
   ```bash
   git clone https://github.com/DhaniDzulkarnain1/Winsorte.git
   cd Winsorte
   ```
2. Open `Winsorte.swiftpm/Package.swift` in Xcode
3. Build and run (⌘R)

---

## How to Play

1. **Select an Algorithm**: Choose from available sorting algorithms (start with Bubble Sort)
2. **Learn the Concept**: Read how the algorithm works
3. **Interactive Challenge**:
   - View an unsorted array of numbers
   - The app highlights two elements to compare
   - Decide: Should they swap positions?
   - Tap "YES, SWAP" or "NO, KEEP"
4. **Get Feedback**: Instant validation with visual and haptic feedback
5. **Complete Sorting**: Continue until the array is fully sorted
6. **Earn Stars**: Performance-based rating (1-3 stars)
7. **Unlock More**: Master algorithms to unlock harder ones

---

## Algorithms Implemented

| Algorithm | Difficulty | Time Complexity | Status |
|-----------|-----------|-----------------|--------|
| **Bubble Sort** | ⭐ Easy | O(n²) | ✅ Unlocked by default |
| **Selection Sort** | ⭐ Easy | O(n²) | 🔒 Unlock by completing Bubble Sort |
| **Insertion Sort** | ⭐⭐ Medium | O(n²) | 🔒 Unlock by completing Selection Sort |
| **Quick Sort** | ⭐⭐⭐ Hard | O(n log n) | 🔒 Unlock by completing Insertion Sort |

---

## Project Structure

```
Winsorte.swiftpm/
├── Sources/
│   ├── App/                    # Entry point
│   │   └── WinsorteApp.swift
│   ├── Core/                   # Shared utilities
│   │   └── Theme/              # Design system
│   │       ├── AppColors.swift
│   │       ├── AppTheme.swift
│   │       └── AppTypography.swift
│   ├── Domain/                 # Business logic
│   │   └── Entities/           # Core models
│   │       ├── Algorithm.swift
│   │       ├── AlgorithmType.swift
│   │       ├── Difficulty.swift
│   │       ├── GameState.swift
│   │       └── SortingStep.swift
│   └── Navigation/             # App routing
│       ├── AppRoute.swift
│       └── Router.swift
└── Package.swift
```

---

## Documentation

- **[Project Brief](WINSORTE_PROJECT_BRIEF.md)**: Complete technical specification and design system
- **[HIG Compliance Report](HIG_2026_COMPLIANCE_SUMMARY.md)**: Detailed Human Interface Guidelines audit
- **[Testing Results](TESTING_RESULTS.md)**: Accessibility and functionality testing log

---

## Accessibility

Winsorte is designed to be usable by everyone:

### Vision
- ✅ **VoiceOver**: Full screen reader support with labels and hints
- ✅ **Dynamic Type**: Text scales up to 310% (exceeds 200% requirement)
- ✅ **High Contrast**: WCAG AAA compliant (14.2:1 light, 12.1:1 dark)
- ✅ **Color Independence**: Information conveyed through icons, text, and shape

### Hearing
- ✅ **Haptic Feedback**: All audio cues have haptic equivalents
- ✅ **Visual Feedback**: No audio-only information

### Mobility
- ✅ **Large Touch Targets**: All buttons exceed 44pt minimum
- ✅ **Simple Gestures**: Tap-only interactions, no complex gestures

### Cognitive
- ✅ **Reduce Motion**: Animations can be disabled, functionality preserved
- ✅ **Clear UI**: Consistent patterns, simple language
- ✅ **No Time Pressure**: User-paced interaction

---

## Testing

Comprehensive testing has been performed across:
- ✅ Reduce Motion (ON/OFF)
- ✅ Dynamic Type (Default to 310% scaling)
- ✅ VoiceOver navigation
- ✅ Light and Dark modes
- ✅ Functional gameplay (all algorithms)

See [TESTING_RESULTS.md](TESTING_RESULTS.md) for detailed test logs.

---

## Roadmap

### Completed
- ✅ Core game mechanics
- ✅ 4 sorting algorithms
- ✅ Full accessibility implementation
- ✅ HIG 2026 compliance
- ✅ Light/Dark mode
- ✅ Comprehensive testing

### Planned
- [ ] More algorithms (Merge Sort, Heap Sort)
- [ ] Custom array input
- [ ] Performance statistics tracking
- [ ] Comparison mode (race between algorithms)
- [ ] iPad-optimized layouts
- [ ] Localization (multiple languages)

---

## Contributing

Contributions are welcome! Whether it's:
- Reporting bugs
- Suggesting new features
- Improving documentation
- Adding new algorithms
- Enhancing accessibility

Please feel free to open an issue or submit a pull request.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author

Built with passion for education and accessibility.

**Contact**: [Open an issue](https://github.com/DhaniDzulkarnain1/Winsorte/issues) for questions or feedback.

---

## Acknowledgments

- Apple's Human Interface Guidelines for design principles
- Swift community for best practices
- Accessibility advocates for inclusive design guidance

---

**Made with ❤️ using Swift and SwiftUI**

*Transforming passive learning into active mastery, one swap at a time.*
