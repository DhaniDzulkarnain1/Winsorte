# Contributing to Winsorte

Thank you for your interest in contributing to Winsorte! This document provides guidelines and instructions for contributing.

## Table of Contents
- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, background, or identity.

### Expected Behavior
- Be respectful and considerate
- Use welcoming and inclusive language
- Accept constructive criticism gracefully
- Focus on what's best for the project and community

### Unacceptable Behavior
- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

---

## How Can I Contribute?

### Reporting Bugs
Before submitting a bug report:
1. Check existing [issues](https://github.com/DhaniDzulkarnain1/Winsorte/issues) to avoid duplicates
2. Test with the latest version
3. Gather relevant information (iOS version, device model, steps to reproduce)

When submitting a bug report, include:
- Clear, descriptive title
- Detailed steps to reproduce
- Expected vs. actual behavior
- Screenshots/videos if applicable
- Device and iOS version

**Template:**
```
**Description**: Brief description of the bug

**Steps to Reproduce**:
1. Step one
2. Step two
3. ...

**Expected Behavior**: What should happen

**Actual Behavior**: What actually happens

**Environment**:
- Device: iPhone 15 Pro
- iOS: 17.2
- App Version: 1.0

**Screenshots**: (if applicable)
```

### Suggesting Enhancements
Enhancement suggestions are welcome! Include:
- Clear description of the feature
- Use case / motivation (why is it useful?)
- Example implementation (if you have ideas)
- Mockups or diagrams (for UI features)

### Adding New Algorithms
Want to add a new sorting algorithm? Great! Follow this process:

1. **Add Algorithm Definition** (`Sources/Domain/Entities/AlgorithmType.swift`)
   ```swift
   case mergeSort
   ```

2. **Create Algorithm Entity** (`Sources/Domain/Entities/Algorithm.swift`)
   ```swift
   Algorithm(
       type: .mergeSort,
       name: "Merge Sort",
       icon: "arrow.triangle.merge",
       difficulty: .hard,
       description: "Divide and conquer sorting..."
   )
   ```

3. **Implement Sorting Logic**
   - Add to game engine
   - Generate step-by-step comparisons
   - Handle edge cases

4. **Add Tests**
   - Unit tests for sorting logic
   - UI tests for gameplay flow

5. **Update Documentation**
   - README.md algorithm table
   - In-app tutorial text

### Improving Accessibility
Accessibility improvements are highly valued! Areas to contribute:
- VoiceOver label improvements
- Dynamic Type edge cases
- Color contrast enhancements
- Reduce Motion alternatives
- Keyboard navigation (future iPad support)

### Documentation
Help make Winsorte easier to understand:
- Fix typos or unclear explanations
- Add code comments
- Create tutorials or guides
- Translate documentation (future)

---

## Development Setup

### Prerequisites
- macOS 13.0+ (for Xcode) or iPadOS 17.0+ (for Swift Playgrounds)
- Xcode 15.0+ or Swift Playgrounds
- Git

### Local Development

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Winsorte.git
   cd Winsorte
   ```

2. **Open in Xcode or Swift Playgrounds**
   ```bash
   open Winsorte.swiftpm/Package.swift
   ```

3. **Build and Run**
   - Xcode: ⌘R
   - Swift Playgrounds: Tap "Run My Code"

4. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

---

## Coding Standards

### Swift Style Guide
Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/):
- Use camelCase for variables, functions
- Use PascalCase for types
- Prefer clear names over brevity
- Add documentation comments for public APIs

### SwiftUI Best Practices
- Keep views small and focused
- Extract reusable components
- Use `@StateObject` for view models
- Avoid massive view files (split into smaller views)

### Architecture
Winsorte follows MVVM + Clean Architecture:
```
Domain (pure logic) → Data → Presentation (UI)
```

**Separation of Concerns:**
- `Domain/`: Business logic, no SwiftUI imports
- `Presentation/`: UI code, imports SwiftUI
- `Core/`: Shared utilities

### Accessibility Requirements
ALL UI contributions must include:
- [ ] VoiceOver labels and hints
- [ ] Dynamic Type support (no hardcoded font sizes)
- [ ] Touch targets ≥ 44pt
- [ ] Works in light AND dark mode
- [ ] Respects Reduce Motion setting
- [ ] Color is not the only indicator

### Code Comments
- Add comments for complex logic
- Document "why" not "what" (code should be self-explanatory)
- Use `///` for documentation comments
- Update comments when changing code

Example:
```swift
/// Calculates the number of comparisons needed for bubble sort
/// - Parameter arraySize: The size of the array to sort
/// - Returns: Number of comparisons in worst case (n² - n) / 2
func calculateComparisons(arraySize: Int) -> Int {
    return (arraySize * arraySize - arraySize) / 2
}
```

---

## Pull Request Process

### Before Submitting
1. **Test Your Changes**
   - Run the app and verify it works
   - Test on different devices/simulators if possible
   - Test with accessibility settings enabled:
     - VoiceOver ON
     - Dynamic Type at largest size
     - Reduce Motion ON
     - Dark mode

2. **Code Quality**
   - No compiler warnings
   - Follow coding standards above
   - Add comments for complex logic

3. **Documentation**
   - Update README.md if adding features
   - Update inline code documentation
   - Add screenshots for UI changes

### Submitting Pull Request

1. **Push Your Branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create PR on GitHub**
   - Go to https://github.com/DhaniDzulkarnain1/Winsorte/pulls
   - Click "New Pull Request"
   - Select your branch

3. **Fill Out PR Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Accessibility improvement

   ## Testing
   - [ ] Tested on iPhone
   - [ ] Tested on iPad
   - [ ] Tested with VoiceOver
   - [ ] Tested with Dynamic Type
   - [ ] Tested in Dark Mode

   ## Screenshots
   (if applicable)

   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Added/updated documentation
   - [ ] No new warnings
   - [ ] Accessibility guidelines met
   ```

4. **Review Process**
   - Maintainer will review within 1-2 weeks
   - Address feedback if requested
   - Once approved, PR will be merged

### Commit Messages
Use clear, descriptive commit messages:

**Format:**
```
[Type] Brief description (50 chars or less)

Detailed explanation if needed (wrap at 72 chars)
- Bullet points for multiple changes
- Explain the "why" not just "what"
```

**Types:**
- `[Feature]` - New feature
- `[Fix]` - Bug fix
- `[Docs]` - Documentation changes
- `[Refactor]` - Code refactoring
- `[Test]` - Adding/updating tests
- `[A11y]` - Accessibility improvements

**Examples:**
```
[Feature] Add Merge Sort algorithm

Implemented merge sort with step-by-step visualization.
- Added MergeSort case to AlgorithmType enum
- Created divide/merge logic with comparison tracking
- Updated algorithm selection UI with new card
```

```
[Fix] Correct Dynamic Type button clipping

Changed button height from fixed to minHeight to prevent
text clipping when Dynamic Type is set to largest size.
Tested at 310% scaling.
```

---

## Questions?

Have questions about contributing? Feel free to:
- Open a [Discussion](https://github.com/DhaniDzulkarnain1/Winsorte/discussions)
- Create an [Issue](https://github.com/DhaniDzulkarnain1/Winsorte/issues) with the "question" label

---

**Thank you for contributing to Winsorte! 🚀**

*Together, we're making computer science education more accessible and engaging for everyone.*
