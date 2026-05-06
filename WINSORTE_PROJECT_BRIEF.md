# WINSORTE - Project Brief for Development

## 🎯 Project Overview

**App Name:** Winsorte
**Tagline:** "Master Sorting, Win the Code"
**Category:** Educational Game / Interactive Learning
**Platform:** iOS (Swift Playgrounds / Xcode)

---

## 📋 App Description

Winsorte adalah game edukasi interaktif yang mengubah cara belajar sorting algorithms dari sekadar "menghafal pseudocode" menjadi "learning by doing". Pemain tidak hanya menonton visualisasi, tetapi **menjadi algorithm-nya sendiri** dengan mengeksekusi setiap langkah sorting secara manual.

### Core Concept: "Be The Algorithm"
- User melihat array of bars (visual representation of numbers)
- User harus melakukan comparison dan swap sesuai aturan algorithm
- App memberikan feedback instant (Correct/Wrong)
- Gamification: streaks, stars, progress unlock

---

## 🎨 Design System

### Color Palette

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| Primary Blue | `#4A90D9` | Buttons, highlights, primary actions |
| Success Green | `#34C759` | Correct answers, sorted elements, success states |
| Error Red | `#FF3B30` | Wrong answers, error states |
| Warning Orange | `#FF9500` | Elements being compared, attention |
| Dark Gray | `#1C1C1E` | Primary text, unsorted elements |
| Light Gray | `#F2F2F7` | Background, cards |
| White | `#FFFFFF` | Card backgrounds, text on dark |

### Typography
- **Primary Font:** SF Pro (System font)
- **Headings:** Bold, larger sizes (28-34pt)
- **Body:** Regular, 17pt
- **Numbers in array:** SF Mono or rounded font for clarity

### Visual Style
- Clean, minimal, modern iOS design
- Rounded corners (16-20px radius)
- Subtle shadows for depth
- Smooth animations (spring effects)
- SF Symbols for all icons
- No custom illustrations needed - use geometric shapes

---

## 🏗️ Architecture

### Pattern: MVVM + Clean Architecture + Feature-First

```
Sources/
├── App/                      # Entry point & global state
├── Core/                     # Shared utilities
│   ├── DI/                   # Dependency Injection
│   ├── Extensions/           # Swift extensions
│   ├── Theme/                # Colors, Typography, Spacing
│   ├── Constants/            # App constants
│   └── Protocols/            # Shared protocols
├── Domain/                   # Business logic (pure Swift)
│   ├── Entities/             # Core data models
│   ├── UseCases/             # Business logic operations
│   └── Repositories/         # Repository protocols
├── Data/                     # Data layer
│   ├── DataSources/          # Local data sources
│   ├── Repositories/         # Repository implementations
│   └── DTOs/                 # Data Transfer Objects
├── Presentation/             # UI Layer
│   ├── Common/Components/    # Reusable UI components
│   └── Features/             # Feature modules
│       ├── Home/
│       ├── AlgorithmSelection/
│       ├── Learning/
│       ├── Game/
│       └── Result/
└── Navigation/               # App routing
```

### State Management
- Native SwiftUI: `@StateObject`, `@ObservedObject`, `@EnvironmentObject`
- `@Published` for reactive properties
- `@MainActor` for thread safety

---

## 📱 Features & Screens

### 1. Home Screen
- App logo and tagline
- "Start Learning" button → Algorithm Selection
- "Free Play" button (optional) → Direct algorithm selection
- Simple, welcoming design

### 2. Algorithm Selection Screen
Grid of algorithm cards showing:
- 🫧 **Bubble Sort** - ⭐ Easy (Unlocked by default)
- 🎯 **Selection Sort** - ⭐ Easy (Locked initially)
- 🃏 **Insertion Sort** - ⭐⭐ Medium (Locked)
- ⚡ **Quick Sort** - ⭐⭐⭐ Hard (Locked/Bonus)

Each card shows:
- Algorithm icon (SF Symbol)
- Name
- Difficulty stars
- Lock/Unlock status
- Completion status (if completed)

### 3. Learning Mode Selection (per Algorithm)
- 📖 **How It Works** - Brief explanation
- 👀 **Watch Demo** - Auto-animated visualization
- 🎮 **Try It Yourself** - Interactive with hints
- 🏆 **Challenge** - No hints, test mastery

### 4. Game Screen (Main Interactive Screen)
Layout:
```
┌─────────────────────────────────────┐
│  ← Back          Bubble Sort    ⭐⭐⭐│
├─────────────────────────────────────┤
│                                     │
│      ██                             │
│      ██  ██                         │
│  ██  ██  ██  ██                     │
│  ██  ██  ██  ██  ██                 │
│  [2] [5] [3] [8] [1]                │
│       ↑   ↑                         │
│    comparing                        │
│                                     │
├─────────────────────────────────────┤
│  "Is 5 > 3? Should you swap?"       │
│                                     │
│  ┌─────────┐      ┌─────────┐       │
│  │   YES   │      │   NO    │       │
│  │  SWAP   │      │  KEEP   │       │
│  └─────────┘      └─────────┘       │
├─────────────────────────────────────┤
│  Step: 3/15   Streak: 5   Errors: 0 │
└─────────────────────────────────────┘
```

Components:
- **ArrayVisualization** - Bars with different heights
- **ComparisonPrompt** - Question about current comparison
- **ActionButtons** - YES/SWAP and NO/KEEP buttons
- **GameStats** - Step counter, streak, errors

### 5. Result Screen
- Completion message
- Stars earned (1-3 based on performance)
- Stats summary (steps, time, accuracy)
- "Next Algorithm" or "Try Again" buttons

---

## 🎮 Game Logic

### Bubble Sort Algorithm
```
1. Compare adjacent elements (i and i+1)
2. If arr[i] > arr[i+1], swap them
3. Move to next pair
4. After each pass, largest element "bubbles" to end
5. Repeat until no swaps needed
```

### Selection Sort Algorithm
```
1. Find minimum element in unsorted portion
2. Swap with first unsorted element
3. Mark that position as sorted
4. Repeat for remaining unsorted portion
```

### Game Flow
1. Generate random array (4-6 elements for playground)
2. Highlight elements to compare (orange color)
3. Show question prompt
4. User taps YES/SWAP or NO/KEEP
5. Validate answer:
   - Correct → Green flash, update array, streak++
   - Wrong → Red flash, show correct answer, reset streak
6. Continue until sorted
7. Show result screen

---

## 🧩 Domain Entities

### AlgorithmType (Enum)
```swift
enum AlgorithmType: String, CaseIterable {
    case bubbleSort
    case selectionSort
    case insertionSort
    case quickSort
}
```

### Algorithm (Entity)
```swift
struct Algorithm {
    let type: AlgorithmType
    let name: String
    let icon: String // SF Symbol name
    let difficulty: Difficulty
    let description: String
}
```

### GameState (Entity)
```swift
struct GameState {
    var array: [Int]
    var currentStep: Int
    var totalSteps: Int
    var compareIndices: (Int, Int)?
    var sortedIndices: Set<Int>
    var streak: Int
    var errors: Int
    var isComplete: Bool
}
```

### SortingStep (Entity)
```swift
struct SortingStep {
    let compareIndices: (Int, Int)
    let shouldSwap: Bool
    let resultArray: [Int]
}
```

---

## 🎬 Animations

All animations should use SwiftUI native animations:

1. **Swap Animation**
   - Two bars smoothly exchange positions
   - Duration: 0.3s with spring effect

2. **Correct Answer**
   - Green flash overlay
   - Scale up slightly then back
   - Haptic feedback (success)

3. **Wrong Answer**
   - Red flash overlay
   - Shake animation
   - Haptic feedback (error)

4. **Comparison Highlight**
   - Bars pulse/glow with orange color
   - Subtle bounce effect

5. **Sorting Complete**
   - All bars turn green sequentially
   - Celebration particles (optional)
   - Scale animation

---

## 📦 Technical Requirements

- **iOS Version:** 17.0+
- **Swift Version:** 5.9+
- **Framework:** SwiftUI
- **No external dependencies** (important for Swift Playgrounds)
- **No network calls** (offline-only)
- **No persistence required** (progress resets each session is OK)

---

## 🚀 Development Priority

### Phase 1: Core Foundation
1. ✅ Project structure
2. Theme/Design system
3. Navigation setup
4. Domain entities

### Phase 2: Home & Selection
5. Home screen UI
6. Algorithm selection screen
7. Algorithm cards component

### Phase 3: Game Core
8. Array visualization component
9. Game view model with Bubble Sort logic
10. Game screen UI
11. Action buttons & feedback

### Phase 4: Polish
12. Animations
13. Result screen
14. Selection Sort implementation
15. Testing & refinement

---

## 💡 Key Principles

1. **Clean Code** - Readable, well-documented
2. **SOLID Principles** - Single responsibility, dependency injection
3. **SwiftUI Best Practices** - Proper state management
4. **Accessibility** - VoiceOver support, dynamic type
5. **Performance** - Smooth 60fps animations
6. **No External Dependencies** - Pure Swift/SwiftUI only

---

## 📝 Notes for Development

- Start with Bubble Sort only, add Selection Sort after core is working
- Keep array size small (4-6 elements) for demo purposes
- Focus on polish over features - better to have 1 algorithm that works perfectly
- Test on both iPhone and iPad layouts

---

## 🎯 Success Criteria

- [ ] App runs without crashes
- [ ] Bubble Sort game is fully playable
- [ ] Animations are smooth and satisfying
- [ ] UI is clean and intuitive
- [ ] Code is well-organized and readable
- [ ] Works on iPhone and iPad
