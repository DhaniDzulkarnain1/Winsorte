import SwiftUI
import AVFoundation

// MARK: - App Entry Point

/// Main app entry point for Winsorte
///
/// Winsorte is an interactive educational game that teaches sorting algorithms
/// through a "Be The Algorithm" approach. Users manually execute each comparison
/// and swap decision, learning by doing rather than passive observation.
///
/// Architecture: MVVM + Clean Architecture
/// - Domain: Business logic (algorithms, game state)
/// - Presentation: SwiftUI views + ViewModels
/// - Core: Shared theme, design system
/// - Navigation: Coordinator pattern with Router
///
/// Key Features:
/// - 4 sorting algorithms (Bubble, Selection, Insertion, Quick)
/// - Progressive unlock system
/// - Star rating based on performance
/// - VoiceOver accessibility support
/// - Pixel art / retro game aesthetic
///
/// Submission: Swift Student Challenge 2026
@main
struct WinsorteApp: App {
    @StateObject private var router = Router()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(router)
            } else {
                NavigationStack(path: $router.path) {
                    HomeView()
                        .navigationDestination(for: AppRoute.self) { route in
                            destinationView(for: route)
                        }
                }
                .environmentObject(router)
            }
        }
    }

    // MARK: - Navigation Destinations

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()

        case .algorithmSelection:
            AlgorithmSelectionView()

        case .learning(let algorithm):
            LearningView(algorithm: algorithm)

        case .game(let algorithm, let mode):
            GameView(algorithm: algorithm, mode: mode)

        case .result(let gameState):
            ResultView(gameState: gameState)
        }
    }
}

// MARK: - Placeholder Views

/// Home screen - Entry point of the app
struct HomeView: View {
    @EnvironmentObject private var router: Router

    var body: some View {
        ZStack {
            // Background
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: AppTheme.spacingXL) {
                Spacer()

                // Logo and Title
                VStack(spacing: AppTheme.spacingM) {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(AppColors.primaryBlue)

                    Text("WINSORTE")
                        .font(.appLargeTitle)
                        .foregroundColor(AppColors.textPrimary)

                    Text("// MASTER SORTING, WIN THE CODE //")
                        .font(.appCallout)
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()

                // Action Buttons
                VStack(spacing: AppTheme.spacing) {
                    Button(action: {
                        router.showAlgorithmSelection()
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("START LEARNING")
                        }
                        .primaryButtonStyle()
                    }
                    .accessibilityLabel("Start learning")
                    .accessibilityHint("Double tap to choose a sorting algorithm to learn")

                    Button(action: {
                        router.showAlgorithmSelection()
                    }) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                            Text("FREE PLAY")
                        }
                        .font(.appButton)
                        .foregroundColor(AppColors.primaryBlue)
                        .frame(height: AppTheme.buttonHeight)
                        .frame(maxWidth: .infinity)
                        .background(AppColors.cardBackground)
                        .cornerRadius(AppTheme.cornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                                .stroke(AppColors.primaryBlue, lineWidth: AppTheme.borderStandard)
                        )
                        .appShadowMedium()
                    }
                    .accessibilityLabel("Free play mode")
                    .accessibilityHint("Double tap to play any algorithm without guided learning")
                }
                .padding(.horizontal, AppTheme.screenPadding)

                Spacer()
                    .frame(height: 40)
            }
        }
    }
}

// MARK: - Onboarding

/// Onboarding flow for first-time users
struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var currentPage = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            TabView(selection: $currentPage) {
                WelcomeScreen(onContinue: { currentPage = 1 })
                    .tag(0)

                HowToPlayScreen(onStart: { hasSeenOnboarding = true })
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Page indicator (custom pixel style)
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    ForEach(0..<2, id: \.self) { index in
                        Rectangle()
                            .fill(currentPage == index ? AppColors.primaryBlue : AppColors.textSecondary.opacity(0.3))
                            .frame(width: currentPage == index ? 24 : 12, height: 12)
                            .cornerRadius(2)
                            .animation(AppTheme.pixelQuick(reduceMotion: reduceMotion), value: currentPage)
                    }
                }
                .padding(.bottom, 60)
            }
        }
    }
}

/// Welcome screen - Page 1
struct WelcomeScreen: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: AppTheme.spacingXL) {
            Spacer()

            // Icon
            Image(systemName: "arrow.up.arrow.down.circle.fill")
                .font(.system(size: 100))
                .foregroundColor(AppColors.primaryBlue)
                .shadow(color: AppColors.pixelShadow, radius: 0, x: 4, y: 4)
                .accessibilityLabel("Winsorte app logo")
                .accessibilityHidden(false)

            // Title
            Text("WINSORTE")
                .font(.appLargeTitle)
                .foregroundColor(AppColors.textPrimary)
                .shadow(color: AppColors.pixelShadow, radius: 0, x: 2, y: 2)

            // Description
            VStack(spacing: AppTheme.spacingM) {
                Text("LEARN SORTING ALGORITHMS")
                    .font(.appTitle3)
                    .foregroundColor(AppColors.textPrimary)

                Text("BY BEING THE ALGORITHM!")
                    .font(.appTitle3)
                    .foregroundColor(AppColors.primaryBlue)

                Text("// Master sorting, win the code //")
                    .font(.appCaption)
                    .foregroundColor(AppColors.textSecondary)
                    .padding(.top, AppTheme.spacingS)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppTheme.screenPadding)

            Spacer()

            // Continue button
            Button(action: {
                SoundManager.shared.playTap()
                onContinue()
            }) {
                HStack {
                    Text("GET STARTED")
                    Image(systemName: "arrow.right")
                }
                .primaryButtonStyle()
            }
            .accessibilityLabel("Get started with Winsorte")
            .accessibilityHint("Double tap to learn how to play")
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.bottom, 80)
        }
    }
}

/// How to play screen - Page 2
struct HowToPlayScreen: View {
    let onStart: () -> Void
    @State private var highlightCompare = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: AppTheme.spacingL) {
            Spacer()

            // Title
            Text("HOW TO PLAY")
                .font(.appTitle2)
                .foregroundColor(AppColors.textPrimary)

            // Visual example
            VStack(spacing: AppTheme.spacingM) {
                // Sample bars
                HStack(spacing: 12) {
                    sampleBar(value: 3, height: 80, isComparing: false)
                    sampleBar(value: 5, height: 120, isComparing: highlightCompare)
                    sampleBar(value: 2, height: 60, isComparing: highlightCompare)
                    sampleBar(value: 7, height: 160, isComparing: false)
                }
                .frame(height: 180)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Example sorting bars showing values 3, 5, 2, and 7. The middle two bars with values 5 and 2 are highlighted for comparison.")

                // Explanation
                Text("COMPARE TWO NUMBERS")
                    .font(.appTitle3)
                    .foregroundColor(AppColors.warningOrange)

                Text("SHOULD YOU SWAP?")
                    .font(.appBody)
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.vertical, AppTheme.spacingL)

            // Sample buttons
            HStack(spacing: AppTheme.spacing) {
                VStack(spacing: 6) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 24))
                    Text("YES")
                        .font(.appButton)
                    Text("SWAP")
                        .font(.appCaption)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                .foregroundColor(.white)
                .background(AppColors.primaryBlue)
                .cornerRadius(AppTheme.cornerRadiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                        .stroke(AppColors.pixelBorder, lineWidth: AppTheme.borderStandard)
                )
                .appShadowMedium()

                VStack(spacing: 6) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 24))
                    Text("NO")
                        .font(.appButton)
                    Text("KEEP")
                        .font(.appCaption)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                .foregroundColor(AppColors.primaryBlue)
                .background(AppColors.cardBackground)
                .cornerRadius(AppTheme.cornerRadiusM)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                        .stroke(AppColors.primaryBlue, lineWidth: AppTheme.borderStandard)
                )
                .appShadowMedium()
            }
            .padding(.horizontal, AppTheme.screenPadding)

            // Stars explanation
            HStack(spacing: 8) {
                Text("⭐⭐⭐")
                    .font(.system(size: 24))
                Text("= PERFECT SCORE!")
                    .font(.appCallout)
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(.top, AppTheme.spacingM)

            Spacer()

            // Start button
            Button(action: {
                SoundManager.shared.playTap()
                onStart()
            }) {
                HStack {
                    Image(systemName: "play.fill")
                    Text("LET'S PLAY!")
                }
                .primaryButtonStyle()
            }
            .accessibilityLabel("Start playing Winsorte")
            .accessibilityHint("Double tap to begin learning sorting algorithms")
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.bottom, 80)
        }
        .onAppear {
            // Animate comparison highlight (only if motion not reduced)
            if !reduceMotion {
                withAnimation(AppTheme.pixelQuick.repeatForever(autoreverses: true)) {
                    highlightCompare = true
                }
            }
        }
    }

    // Sample bar for demonstration
    private func sampleBar(value: Int, height: CGFloat, isComparing: Bool) -> some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(isComparing ? AppColors.warningOrange : AppColors.primaryBlue)
                .frame(width: 50, height: height)
                .overlay(
                    Rectangle()
                        .strokeBorder(
                            isComparing ? Color.white : AppColors.pixelBorder,
                            lineWidth: isComparing ? AppTheme.borderThick : AppTheme.borderStandard
                        )
                )
                .shadow(
                    color: isComparing ? AppColors.warningOrange.opacity(0.6) : AppColors.pixelShadow.opacity(0.5),
                    radius: 0,
                    x: 3,
                    y: 3
                )

            Text("\(value)")
                .font(.appArrayNumber)
                .foregroundColor(.white)
                .shadow(color: AppColors.pixelShadow.opacity(0.5), radius: 0, x: 1, y: 1)
        }
    }
}

/// Learning screen with game mode options
struct LearningView: View {
    let algorithm: Algorithm
    @EnvironmentObject private var router: Router

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: AppTheme.spacingXL) {
                Spacer()

                // Algorithm icon
                Image(systemName: algorithm.iconName)
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.primaryBlue)

                // Description
                VStack(spacing: AppTheme.spacingM) {
                    Text(algorithm.name)
                        .font(.appTitle)
                        .foregroundColor(AppColors.textPrimary)

                    Text(algorithm.description)
                        .font(.appBody)
                        .foregroundColor(AppColors.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.screenPadding)
                }

                Spacer()

                // Game mode buttons
                VStack(spacing: AppTheme.spacing) {
                    // Start Game button (Practice mode)
                    Button(action: {
                        router.startGame(algorithm: algorithm, mode: .practice)
                    }) {
                        HStack {
                            Image(systemName: "gamecontroller.fill")
                            Text("Start Learning")
                        }
                        .primaryButtonStyle()
                    }

                }
                .padding(.horizontal, AppTheme.screenPadding)

                Spacer().frame(height: 40)
            }
        }
        .navigationTitle(algorithm.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Main interactive game screen
struct GameView: View {
    let algorithm: Algorithm
    let mode: GameMode

    @EnvironmentObject private var router: Router
    @StateObject private var viewModel: GameViewModel
    @State private var debugMode: Bool = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(algorithm: Algorithm, mode: GameMode) {
        self.algorithm = algorithm
        self.mode = mode
        self._viewModel = StateObject(wrappedValue: GameViewModel(
            algorithm: algorithm.type,
            mode: mode
        ))
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: AppTheme.spacingL) {
                statsBar
                Spacer().frame(height: 20)

                ArrayVisualizationView(
                    array: viewModel.gameState.array,
                    compareIndices: viewModel.gameState.compareIndices,
                    sortedIndices: viewModel.gameState.sortedIndices
                )

                Spacer().frame(height: 20)

                if !viewModel.gameState.isComplete {
                    questionPrompt
                } else {
                    completionView
                }

                Spacer()

                if !viewModel.gameState.isComplete {
                    actionButtons
                }
            }
            .padding(.top, AppTheme.spacingL)

            if viewModel.showFeedback {
                feedbackOverlay
            }
        }
        .navigationTitle(algorithm.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { debugMode.toggle() }) {
                    Image(systemName: debugMode ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(debugMode ? AppColors.successGreen : AppColors.textSecondary)
                }
            }
        }
    }

    private var statsBar: some View {
        HStack(spacing: AppTheme.spacingL) {
            statItem(icon: "number.circle.fill", label: viewModel.progressText, color: AppColors.primaryBlue)
            Spacer()
            statItem(icon: "flame.fill", label: "Streak: \(viewModel.gameState.streak)", color: AppColors.warningOrange)
            statItem(icon: "xmark.circle.fill", label: "Errors: \(viewModel.gameState.errors)", color: AppColors.errorRed)
        }
        .padding(.horizontal, AppTheme.screenPadding)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(viewModel.progressText). Streak: \(viewModel.gameState.streak) correct in a row. Errors: \(viewModel.gameState.errors)")
    }

    private func statItem(icon: String, label: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).foregroundColor(color)
            Text(label).font(.appGameStats).foregroundColor(AppColors.textPrimary)
        }
    }

    private var questionPrompt: some View {
        VStack(spacing: AppTheme.spacingM) {
            Text("Question").font(.appCaption).foregroundStyle(.secondary).textCase(.uppercase)
            Text(viewModel.questionText).font(.appTitle3).foregroundStyle(.primary)
                .multilineTextAlignment(.center).padding(.horizontal, AppTheme.screenPadding)

            if debugMode, let currentStep = viewModel.currentStep {
                HStack(spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(AppColors.warningOrange)
                        .font(.system(size: 14))
                    Text("Correct Answer: \(currentStep.shouldSwap ? "YES (SWAP)" : "NO (KEEP)")")
                        .font(.appCaption)
                        .foregroundColor(AppColors.warningOrange)
                        .bold()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(AppColors.warningOrange.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, AppTheme.spacing)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(AppTheme.cornerRadiusM)
        .shadow(color: AppColors.pixelShadow.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal, AppTheme.screenPadding)
    }

    private var actionButtons: some View {
        VStack(spacing: 0) {
            HStack(spacing: AppTheme.spacing) {
                Button(action: { viewModel.handleAnswer(shouldSwap: true) }) {
                    VStack(spacing: 8) {
                        Image(systemName: "arrow.left.arrow.right").font(.system(size: 24))
                        Text("YES").font(.appButton)
                        Text("SWAP").font(.appCaption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 100)
                    .padding(.vertical, 12)
                    .foregroundColor(.white).background(AppColors.primaryBlue)
                    .cornerRadius(AppTheme.cornerRadiusM)
                }
                .disabled(viewModel.showFeedback)
                .accessibilityLabel("Yes, swap")
                .accessibilityHint("Double tap to swap the compared numbers")

                Button(action: { viewModel.handleAnswer(shouldSwap: false) }) {
                    VStack(spacing: 8) {
                        Image(systemName: "hand.raised.fill").font(.system(size: 24))
                        Text("NO").font(.appButton)
                        Text("KEEP").font(.appCaption)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 100)
                    .padding(.vertical, 12)
                    .foregroundColor(AppColors.primaryBlue).background(AppColors.cardBackground)
                    .cornerRadius(AppTheme.cornerRadiusM)
                    .overlay(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM).stroke(AppColors.primaryBlue, lineWidth: 2))
                }
                .disabled(viewModel.showFeedback)
                .accessibilityLabel("No, keep")
                .accessibilityHint("Double tap to keep the numbers in current order")
            }
            .padding(.horizontal, AppTheme.screenPadding)
            .padding(.vertical, AppTheme.spacingL)
        }
        .background(.ultraThinMaterial)
        .shadow(color: AppColors.pixelShadow.opacity(0.3), radius: 0, x: 0, y: -4)
    }

    private var feedbackOverlay: some View {
        ZStack {
            AppColors.background.opacity(0.95).ignoresSafeArea()
            VStack(spacing: AppTheme.spacingL) {
                Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(viewModel.isCorrect ? AppColors.successGreen : AppColors.errorRed)
                    .scaleEffect(viewModel.showFeedback ? 1.0 : 0.5)
                    .animation(AppTheme.pixelQuick(reduceMotion: reduceMotion), value: viewModel.showFeedback)
                    .shadow(color: AppColors.pixelShadow, radius: 0, x: 4, y: 4)
                Text(viewModel.isCorrect ? "CORRECT!" : "WRONG!")
                    .font(.appTitle)
                    .foregroundColor(viewModel.isCorrect ? AppColors.successGreen : AppColors.errorRed)
                    .opacity(viewModel.showFeedback ? 1.0 : 0.0)
                    .animation(AppTheme.pixelAnimation(reduceMotion: reduceMotion), value: viewModel.showFeedback)
                    .shadow(color: AppColors.pixelShadow, radius: 0, x: 2, y: 2)
            }
        }
        .transition(.opacity)
        .animation(AppTheme.pixelQuick(reduceMotion: reduceMotion), value: viewModel.showFeedback)
    }

    private var completionView: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColors.primaryBlue.opacity(0.1),
                    AppColors.successGreen.opacity(0.05),
                    AppColors.background
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Confetti background
            ConfettiView()
                .allowsHitTesting(false)

            // Completion content
            VStack(spacing: AppTheme.spacingL) {
                Text("🎉")
                    .font(.system(size: 60))
                    .scaleEffect(1.0)
                    .animation(
                        reduceMotion ? nil : AppTheme.pixelAnimation.delay(0.1),
                        value: viewModel.gameState.isComplete
                    )

                Text("Sorting Complete!")
                    .font(.appTitle)
                    .foregroundColor(AppColors.textPrimary)

                VStack(spacing: AppTheme.spacingS) {
                    Text("Stars: \(String(repeating: "⭐", count: viewModel.gameState.starRating))")
                        .font(.appTitle2)
                        .foregroundStyle(.primary)

                    Divider()

                    HStack(spacing: AppTheme.spacingL) {
                        VStack(spacing: 4) {
                            Text("\(String(format: "%.0f%%", viewModel.gameState.accuracy))")
                                .font(.appTitle2)
                                .foregroundColor(AppColors.successGreen)
                            Text("Accuracy")
                                .font(.appCaption)
                                .foregroundStyle(.secondary)
                        }

                        Divider()
                            .frame(height: 40)

                        VStack(spacing: 4) {
                            Text("\(viewModel.gameState.errors)")
                                .font(.appTitle2)
                                .foregroundColor(AppColors.errorRed)
                            Text("Errors")
                                .font(.appCaption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(AppTheme.spacingM)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Completed! You earned \(viewModel.gameState.starRating) star\(viewModel.gameState.starRating == 1 ? "" : "s"). Accuracy: \(String(format: "%.0f", viewModel.gameState.accuracy)) percent. Errors: \(viewModel.gameState.errors)")
                .background(.regularMaterial)
                .cornerRadius(AppTheme.cornerRadiusL)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusL)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [
                                AppColors.successGreen.opacity(0.3),
                                AppColors.primaryBlue.opacity(0.3)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 2)
                )
                .shadow(color: AppColors.pixelShadow.opacity(0.2), radius: 12, x: 0, y: 6)

                VStack(spacing: AppTheme.spacing) {
                    Button(action: { viewModel.restart() }) {
                        Text("Try Again").primaryButtonStyle()
                    }
                    .accessibilityLabel("Try this algorithm again")
                    .accessibilityHint("Double tap to restart with a new array")

                    Button(action: { router.navigateBack() }) {
                        Text("Back to Algorithms")
                            .font(.appButton)
                            .foregroundColor(AppColors.primaryBlue)
                            .frame(height: AppTheme.buttonHeight)
                            .frame(maxWidth: .infinity)
                    }
                    .accessibilityLabel("Back to algorithm selection")
                    .accessibilityHint("Double tap to choose a different algorithm")
                }
                .padding(.horizontal, AppTheme.screenPadding)
            }
            .padding(AppTheme.spacingL)
        }
    }
}

/// Placeholder for Result screen
struct ResultView: View {
    let gameState: GameState

    var body: some View {
        VStack(spacing: AppTheme.spacingL) {
            Text("Results")
                .font(.appTitle)

            Text("Algorithm: \(gameState.algorithm.displayName)")
            Text("Stars: \(String(repeating: "⭐", count: gameState.starRating))")
            Text("Errors: \(gameState.errors)")
            Text("Accuracy: \(String(format: "%.1f%%", gameState.accuracy))")
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Algorithm Selection Screen

/// Algorithm Selection screen - Choose which algorithm to learn
struct AlgorithmSelectionView: View {
    @EnvironmentObject private var router: Router
    @ObservedObject private var progressManager = AlgorithmProgressManager.shared

    private let columns = [
        GridItem(.flexible(), spacing: AppTheme.spacing),
        GridItem(.flexible(), spacing: AppTheme.spacing)
    ]

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppTheme.spacingL) {
                    headerView

                    LazyVGrid(columns: columns, spacing: AppTheme.spacing) {
                        ForEach(progressManager.algorithms) { algorithm in
                            AlgorithmCard(algorithm: algorithm) {
                                handleAlgorithmTap(algorithm)
                            }
                        }
                    }
                    .padding(.horizontal, AppTheme.screenPadding)
                }
                .padding(.vertical, AppTheme.spacingL)
            }
        }
        .navigationTitle("Choose Algorithm")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            progressManager.loadProgress()
        }
    }

    private var headerView: some View {
        VStack(spacing: AppTheme.spacingS) {
            let completedCount = progressManager.algorithms.filter { $0.isCompleted }.count
            if completedCount > 0 {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColors.successGreen)
                    Text("\(completedCount) of \(progressManager.algorithms.count) completed")
                        .font(.appCallout)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, AppTheme.screenPadding)
            }
            Text("Select an algorithm to start learning")
                .font(.appBody)
                .foregroundColor(AppColors.textSecondary)
                .padding(.horizontal, AppTheme.screenPadding)
        }
    }

    private func handleAlgorithmTap(_ algorithm: Algorithm) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        SoundManager.shared.playTap()
        router.showLearning(for: algorithm)
    }
}

// MARK: - Algorithm Card

struct AlgorithmCard: View {
    let algorithm: Algorithm
    let onTap: () -> Void

    var body: some View {
        Button(action: { if algorithm.isUnlocked || algorithm.isCompleted { onTap() } }) {
            VStack(spacing: AppTheme.spacingM) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: algorithm.iconName)
                        .font(.system(size: 40))
                        .foregroundColor(iconColor)
                        .frame(width: 80, height: 80)
                        .background(iconBackgroundColor)
                        .clipShape(Circle())

                    if algorithm.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.successGreen)
                            .background(Circle().fill(Color.white).padding(2))
                            .offset(x: 6, y: -6)
                    } else if !algorithm.isUnlocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(6)
                            .background(AppColors.textSecondary)
                            .clipShape(Circle())
                            .offset(x: 4, y: -4)
                    }
                }

                Text(algorithm.name)
                    .font(.appTitle3)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                HStack(spacing: 2) {
                    ForEach(0..<algorithm.difficulty.stars, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(AppColors.warningOrange)
                    }
                }

                Text(algorithm.difficulty.displayName)
                    .font(.appCaption)
                    .foregroundColor(AppColors.textSecondary)
            }
            .padding(AppTheme.spacing)
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(.regularMaterial)
            .cornerRadius(AppTheme.cornerRadiusL)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusL)
                    .stroke(borderColor, lineWidth: algorithm.isUnlocked ? 0 : 2)
            )
            .shadow(color: AppColors.pixelShadow.opacity(0.2), radius: 8, x: 0, y: 4)
            .opacity(algorithm.isUnlocked || algorithm.isCompleted ? 1.0 : 0.6)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!algorithm.isUnlocked && !algorithm.isCompleted)
        .accessibilityLabel("\(algorithm.name), \(algorithm.difficulty.displayName) difficulty")
        .accessibilityHint(algorithm.isUnlocked || algorithm.isCompleted ? "Double tap to learn this algorithm" : "Locked. Complete previous algorithms to unlock")
        .accessibilityValue(algorithm.isCompleted ? "Completed" : "Not completed")
        .accessibilityAddTraits(algorithm.isUnlocked ? [] : .isButton)
    }

    private var iconColor: Color {
        (algorithm.isUnlocked || algorithm.isCompleted) ? AppColors.primaryBlue : AppColors.textSecondary
    }

    private var iconBackgroundColor: Color {
        (algorithm.isUnlocked || algorithm.isCompleted) ? AppColors.primaryBlue.opacity(0.1) : AppColors.textSecondary.opacity(0.2)
    }

    private var textColor: Color {
        (algorithm.isUnlocked || algorithm.isCompleted) ? AppColors.textPrimary : AppColors.textSecondary
    }

    private var borderColor: Color {
        (algorithm.isUnlocked || algorithm.isCompleted) ? .clear : AppColors.textSecondary.opacity(0.3)
    }
}

// MARK: - Pixel Button Style (No smooth scale - instant press effect)

struct ScaleButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .offset(y: configuration.isPressed ? 2 : 0)  // Pixel-style button press
            .animation(AppTheme.pixelQuick(reduceMotion: reduceMotion), value: configuration.isPressed)
    }
}

// MARK: - Algorithm Progress Manager

/// Manages algorithm unlock status and completion tracking
@MainActor
final class AlgorithmProgressManager: ObservableObject {
    static let shared = AlgorithmProgressManager()

    @Published var algorithms: [Algorithm] = []

    private let defaults = UserDefaults.standard
    private let unlockedKey = "unlocked_algorithms"
    private let completedKey = "completed_algorithms"
    private let bestScoresKey = "best_scores"

    private init() {
        loadProgress()
    }

    func loadProgress() {
        let unlockedIds = defaults.stringArray(forKey: unlockedKey) ?? ["bubbleSort"]
        let completedIds = defaults.stringArray(forKey: completedKey) ?? []
        let bestScores = defaults.dictionary(forKey: bestScoresKey) as? [String: Int] ?? [:]

        algorithms = Algorithm.allAlgorithms().map { algo in
            Algorithm(
                type: algo.type,
                difficulty: algo.difficulty,
                isUnlocked: unlockedIds.contains(algo.id),
                isCompleted: completedIds.contains(algo.id),
                bestScore: bestScores[algo.id]
            )
        }
    }

    func completeAlgorithm(type: AlgorithmType, stars: Int) {
        guard let index = algorithms.firstIndex(where: { $0.type == type }) else { return }

        // Mark as completed
        if !algorithms[index].isCompleted {
            algorithms[index].isCompleted = true
            var completedIds = defaults.stringArray(forKey: completedKey) ?? []
            if !completedIds.contains(algorithms[index].id) {
                completedIds.append(algorithms[index].id)
                defaults.set(completedIds, forKey: completedKey)
            }
        }

        // Update best score
        var bestScores = defaults.dictionary(forKey: bestScoresKey) as? [String: Int] ?? [:]
        if let currentBest = bestScores[algorithms[index].id] {
            if stars > currentBest {
                bestScores[algorithms[index].id] = stars
                algorithms[index].bestScore = stars
            }
        } else {
            bestScores[algorithms[index].id] = stars
            algorithms[index].bestScore = stars
        }
        defaults.set(bestScores, forKey: bestScoresKey)

        // Unlock next algorithm if got 2+ stars
        if stars >= 2 {
            unlockNextAlgorithm(after: type)
        }
    }

    private func unlockNextAlgorithm(after type: AlgorithmType) {
        // Play unlock sound for achievement
        SoundManager.shared.playUnlock()
        let nextType: AlgorithmType? = {
            switch type {
            case .bubbleSort: return .selectionSort
            case .selectionSort: return .insertionSort
            case .insertionSort: return .quickSort
            case .quickSort: return nil
            }
        }()

        guard let next = nextType,
              let index = algorithms.firstIndex(where: { $0.type == next }),
              !algorithms[index].isUnlocked else { return }

        algorithms[index].isUnlocked = true

        var unlockedIds = defaults.stringArray(forKey: unlockedKey) ?? []
        unlockedIds.append(algorithms[index].id)
        defaults.set(unlockedIds, forKey: unlockedKey)
    }

    func resetProgress() {
        defaults.removeObject(forKey: unlockedKey)
        defaults.removeObject(forKey: completedKey)
        defaults.removeObject(forKey: bestScoresKey)
        loadProgress()
    }
}

// MARK: - Game Components

/// View model for the interactive sorting game
@MainActor
final class GameViewModel: ObservableObject {
    @Published var gameState: GameState
    @Published var showFeedback: Bool = false
    @Published var isCorrect: Bool = false

    private let algorithm: AlgorithmType
    private let mode: GameMode
    private var sortingSteps: [SortingStep] = []
    private var currentStepIndex: Int = 0

    init(algorithm: AlgorithmType, mode: GameMode) {
        self.algorithm = algorithm
        self.mode = mode
        let randomArray = Self.generateRandomArray(count: 5, maxValue: 9)
        self.sortingSteps = Self.generateSteps(for: randomArray, algorithm: algorithm)
        self.gameState = GameState(array: randomArray, algorithm: algorithm, totalSteps: sortingSteps.count)
        if !sortingSteps.isEmpty {
            gameState.updateCompareIndices(sortingSteps[0].compareIndices)
        }
    }

    // MARK: - Helper Methods

    private static func generateRandomArray(count: Int = 5, maxValue: Int = 9) -> [Int] {
        var array: [Int] = []
        var used = Set<Int>()
        while array.count < count {
            let value = Int.random(in: 1...maxValue)
            if !used.contains(value) {
                array.append(value)
                used.insert(value)
            }
        }
        return array
    }

    private static func generateSteps(for array: [Int], algorithm: AlgorithmType) -> [SortingStep] {
        switch algorithm {
        case .bubbleSort:
            return BubbleSortUseCase().generateSteps(for: array)
        case .selectionSort:
            return SelectionSortUseCase().generateSteps(for: array)
        case .insertionSort:
            return InsertionSortUseCase().generateSteps(for: array)
        case .quickSort:
            return QuickSortUseCase().generateSteps(for: array)
        }
    }

    var currentStep: SortingStep? {
        guard currentStepIndex < sortingSteps.count else { return nil }
        return sortingSteps[currentStepIndex]
    }

    var questionText: String {
        currentStep?.questionText ?? "Sorting complete!"
    }

    var progressText: String {
        "Step \(currentStepIndex + 1) of \(sortingSteps.count)"
    }

    func handleAnswer(shouldSwap: Bool) {
        guard let step = currentStep else { return }
        let correct = shouldSwap == step.shouldSwap

        if correct {
            gameState.recordCorrectMove()
            isCorrect = true
            gameState.array = step.resultArray
            if let newlySorted = step.newlySortedIndices {
                newlySorted.forEach { gameState.markAsSorted($0) }
            }

            // Play correct sound
            SoundManager.shared.playCorrect()

            // Play swap sound if swapping
            if shouldSwap {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    SoundManager.shared.playSwap()
                }
            }
        } else {
            gameState.recordError()
            isCorrect = false

            // Play wrong sound
            SoundManager.shared.playWrong()
        }

        showFeedback = true
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(correct ? .success : .error)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.nextStep()
        }
    }

    private func nextStep() {
        showFeedback = false
        currentStepIndex += 1
        gameState.nextStep()

        if currentStepIndex < sortingSteps.count {
            let nextStep = sortingSteps[currentStepIndex]
            gameState.updateCompareIndices(nextStep.compareIndices)
        } else {
            completeGame()
        }
    }

    private func completeGame() {
        gameState.updateCompareIndices(nil)
        gameState.complete()
        for i in 0..<gameState.array.count {
            gameState.markAsSorted(i)
        }

        // Play completion sound
        SoundManager.shared.playComplete()

        // Save progress and unlock next algorithm
        AlgorithmProgressManager.shared.completeAlgorithm(
            type: algorithm,
            stars: gameState.starRating
        )

        // Celebration haptic pattern
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let impact = UIImpactFeedbackGenerator(style: .heavy)
            impact.impactOccurred()
        }
    }

    func restart() {
        let randomArray = Self.generateRandomArray(count: 5, maxValue: 9)
        self.sortingSteps = Self.generateSteps(for: randomArray, algorithm: algorithm)
        self.gameState = GameState(array: randomArray, algorithm: algorithm, totalSteps: sortingSteps.count)
        self.currentStepIndex = 0
        self.showFeedback = false
        if !sortingSteps.isEmpty {
            gameState.updateCompareIndices(sortingSteps[0].compareIndices)
        }
    }
}

/// Visual bar representing an array element - PIXEL ART STYLE
struct ArrayBar: View {
    let value: Int
    let maxValue: Int
    let state: BarState

    @State private var isPulsing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    enum BarState {
        case normal, comparing, sorted, correct, wrong
    }

    var body: some View {
        VStack(spacing: 6) {
            // Pixel block with thick border
            Rectangle()  // Square corners for pixel style
                .fill(barColor)
                .frame(height: barHeight)
                .overlay(
                    // Thick pixel border
                    Rectangle()
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                .overlay(
                    // Inner highlight for 3D pixel effect
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            Rectangle()
                                .fill(AppColors.pixelHighlight.opacity(0.2))
                                .frame(height: 3)
                            Spacer()
                        }
                    }
                )
                .shadow(
                    color: shadowColor,
                    radius: 0,  // No blur for pixel art
                    x: isPulsing ? 3 : 4,
                    y: isPulsing ? 3 : 4
                )
                .offset(
                    x: state == .comparing && isPulsing ? -1 : 0,
                    y: state == .comparing && isPulsing ? -1 : 0
                )
                .animation(
                    reduceMotion ? nil : AppTheme.pixelQuick.repeatForever(autoreverses: true),
                    value: isPulsing
                )
                .onChange(of: state) { _, newState in
                    isPulsing = (newState == .comparing) && !reduceMotion
                }

            // Pixel-style number display
            Text("\(value)")
                .font(.appArrayNumber)
                .foregroundColor(textColor)
                .shadow(
                    color: AppColors.pixelShadow.opacity(0.5),
                    radius: 0,
                    x: 1,
                    y: 1
                )
        }
        .frame(maxWidth: .infinity)
    }

    private var barHeight: CGFloat {
        let minHeight: CGFloat = 40
        let maxHeight: CGFloat = 200
        let ratio = CGFloat(value) / CGFloat(maxValue)
        return minHeight + (maxHeight - minHeight) * ratio
    }

    private var barColor: Color {
        switch state {
        case .normal: return AppColors.primaryBlue
        case .comparing: return AppColors.warningOrange
        case .sorted: return AppColors.successGreen
        case .correct: return AppColors.successGreen
        case .wrong: return AppColors.errorRed
        }
    }

    private var borderColor: Color {
        switch state {
        case .comparing: return Color.white
        case .sorted: return AppColors.pixelBorder
        case .correct: return Color.white
        case .wrong: return Color.white
        default: return AppColors.pixelBorder
        }
    }

    private var borderWidth: CGFloat {
        state == .comparing ? AppTheme.borderThick : AppTheme.borderStandard
    }

    private var shadowColor: Color {
        state == .comparing
            ? AppColors.warningOrange.opacity(0.6)
            : AppColors.pixelShadow.opacity(0.7)
    }

    private var textColor: Color {
        .white  // Always white for contrast on vibrant colors
    }
}

/// Displays array as visual bars
struct ArrayVisualizationView: View {
    let array: [Int]
    let compareIndices: (Int, Int)?
    let sortedIndices: Set<Int>

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(array.enumerated()), id: \.offset) { index, value in
                ArrayBar(value: value, maxValue: array.max() ?? 10, state: barState(for: index))
                    .id("\(index)-\(value)")
            }
        }
        .padding(.horizontal, AppTheme.screenPadding)
        .frame(maxWidth: .infinity)
        .frame(height: 280)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(arrayAccessibilityLabel)
    }

    private func barState(for index: Int) -> ArrayBar.BarState {
        if sortedIndices.contains(index) { return .sorted }
        if let (i, j) = compareIndices, index == i || index == j { return .comparing }
        return .normal
    }

    private var arrayAccessibilityLabel: String {
        let values = array.map { String($0) }.joined(separator: ", ")
        var label = "Array with values: \(values). "

        if let (i, j) = compareIndices {
            label += "Comparing \(array[i]) and \(array[j]). "
        }

        if !sortedIndices.isEmpty {
            let sortedCount = sortedIndices.count
            label += "\(sortedCount) element\(sortedCount == 1 ? "" : "s") sorted."
        }

        return label
    }
}

/// Use case for generating Bubble Sort steps
struct BubbleSortUseCase {
    func generateSteps(for array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var workingArray = array
        let n = workingArray.count

        for i in 0..<n {
            var swapped = false
            for j in 0..<(n - i - 1) {
                let leftIndex = j
                let rightIndex = j + 1
                let leftValue = workingArray[leftIndex]
                let rightValue = workingArray[rightIndex]
                let shouldSwap = leftValue > rightValue

                if shouldSwap {
                    workingArray.swapAt(leftIndex, rightIndex)
                    swapped = true
                }

                let step = SortingStep(
                    compareIndices: (leftIndex, rightIndex),
                    shouldSwap: shouldSwap,
                    resultArray: workingArray,
                    description: shouldSwap ? "Swap \(leftValue) and \(rightValue)" : "Keep \(leftValue) and \(rightValue)",
                    newlySortedIndices: nil
                )
                steps.append(step)
            }

            if !steps.isEmpty {
                let lastSortedIndex = n - i - 1
                let lastStep = steps.removeLast()
                let updatedStep = SortingStep(
                    compareIndices: lastStep.compareIndices,
                    shouldSwap: lastStep.shouldSwap,
                    resultArray: lastStep.resultArray,
                    description: lastStep.description,
                    newlySortedIndices: Set([lastSortedIndex])
                )
                steps.append(updatedStep)
            }

            if !swapped { break }
        }

        return steps
    }

    func generateRandomArray(count: Int = 5, maxValue: Int = 9) -> [Int] {
        var array: [Int] = []
        var used = Set<Int>()
        while array.count < count {
            let value = Int.random(in: 1...maxValue)
            if !used.contains(value) {
                array.append(value)
                used.insert(value)
            }
        }
        return array
    }
}

/// Use case for generating Selection Sort steps
struct SelectionSortUseCase {
    func generateSteps(for array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var workingArray = array
        let n = workingArray.count

        for i in 0..<(n - 1) {
            var minIndex = i

            // Find minimum in unsorted portion
            for j in (i + 1)..<n {
                let currentValue = workingArray[j]
                let minValue = workingArray[minIndex]

                // Ask: Is current < min?
                let shouldSwap = currentValue < minValue

                // Create comparison step
                let step = SortingStep(
                    compareIndices: (j, minIndex),
                    shouldSwap: shouldSwap,
                    resultArray: workingArray,
                    description: shouldSwap
                        ? "\(currentValue) is smaller than \(minValue)"
                        : "\(currentValue) is not smaller than \(minValue)",
                    newlySortedIndices: nil
                )
                steps.append(step)

                // Update minIndex if found smaller
                if shouldSwap {
                    minIndex = j
                }
            }

            // Swap minimum to correct position
            if minIndex != i {
                workingArray.swapAt(i, minIndex)

                // Add swap step
                let swapStep = SortingStep(
                    compareIndices: (i, minIndex),
                    shouldSwap: true,
                    resultArray: workingArray,
                    description: "Swap \(workingArray[minIndex]) and \(workingArray[i])",
                    newlySortedIndices: Set([i])
                )
                steps.append(swapStep)
            } else {
                // Mark as sorted even if no swap needed
                if !steps.isEmpty {
                    let lastStep = steps.removeLast()
                    let updatedStep = SortingStep(
                        compareIndices: lastStep.compareIndices,
                        shouldSwap: lastStep.shouldSwap,
                        resultArray: lastStep.resultArray,
                        description: lastStep.description,
                        newlySortedIndices: Set([i])
                    )
                    steps.append(updatedStep)
                }
            }
        }

        // Mark last element as sorted
        if !steps.isEmpty {
            let lastStep = steps.removeLast()
            let updatedStep = SortingStep(
                compareIndices: lastStep.compareIndices,
                shouldSwap: lastStep.shouldSwap,
                resultArray: lastStep.resultArray,
                description: lastStep.description,
                newlySortedIndices: lastStep.newlySortedIndices?.union([n - 1]) ?? Set([n - 1])
            )
            steps.append(updatedStep)
        }

        return steps
    }

    func generateRandomArray(count: Int = 5, maxValue: Int = 9) -> [Int] {
        var array: [Int] = []
        var used = Set<Int>()
        while array.count < count {
            let value = Int.random(in: 1...maxValue)
            if !used.contains(value) {
                array.append(value)
                used.insert(value)
            }
        }
        return array
    }
}

/// Use case for generating Insertion Sort steps
struct InsertionSortUseCase {
    func generateSteps(for array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var workingArray = array
        let n = workingArray.count

        for i in 1..<n {
            let key = workingArray[i]
            var j = i - 1

            // Compare key with sorted portion
            while j >= 0 {
                let compareValue = workingArray[j]
                let shouldSwap = key < compareValue

                let step = SortingStep(
                    compareIndices: (j + 1, j),
                    shouldSwap: shouldSwap,
                    resultArray: workingArray,
                    description: shouldSwap
                        ? "\(key) should move left past \(compareValue)"
                        : "\(key) is in correct position",
                    newlySortedIndices: nil
                )
                steps.append(step)

                if shouldSwap {
                    workingArray[j + 1] = workingArray[j]
                    j -= 1
                } else {
                    break
                }
            }

            workingArray[j + 1] = key

            // Mark sorted portion
            if !steps.isEmpty {
                let lastStep = steps.removeLast()
                let updatedStep = SortingStep(
                    compareIndices: lastStep.compareIndices,
                    shouldSwap: lastStep.shouldSwap,
                    resultArray: workingArray,
                    description: lastStep.description,
                    newlySortedIndices: Set(0...i)
                )
                steps.append(updatedStep)
            }
        }

        return steps
    }

    func generateRandomArray(count: Int = 5, maxValue: Int = 9) -> [Int] {
        var array: [Int] = []
        var used = Set<Int>()
        while array.count < count {
            let value = Int.random(in: 1...maxValue)
            if !used.contains(value) {
                array.append(value)
                used.insert(value)
            }
        }
        return array
    }
}

/// Use case for generating Quick Sort steps (simplified for education)
struct QuickSortUseCase {
    func generateSteps(for array: [Int]) -> [SortingStep] {
        var steps: [SortingStep] = []
        var workingArray = array

        quickSort(&workingArray, low: 0, high: array.count - 1, steps: &steps)

        return steps
    }

    private func quickSort(_ array: inout [Int], low: Int, high: Int, steps: inout [SortingStep]) {
        guard low < high else { return }

        let pivotIndex = partition(&array, low: low, high: high, steps: &steps)

        // Recursively sort left and right
        quickSort(&array, low: low, high: pivotIndex - 1, steps: &steps)
        quickSort(&array, low: pivotIndex + 1, high: high, steps: &steps)
    }

    private func partition(_ array: inout [Int], low: Int, high: Int, steps: inout [SortingStep]) -> Int {
        let pivot = array[high]
        var i = low - 1

        for j in low..<high {
            let currentValue = array[j]
            let shouldSwap = currentValue < pivot

            // Comparison step
            let step = SortingStep(
                compareIndices: (j, high),
                shouldSwap: shouldSwap,
                resultArray: array,
                description: shouldSwap
                    ? "\(currentValue) is less than pivot \(pivot)"
                    : "\(currentValue) is not less than pivot \(pivot)",
                newlySortedIndices: nil
            )
            steps.append(step)

            if shouldSwap {
                i += 1
                if i != j {
                    array.swapAt(i, j)

                    // Swap step
                    let swapStep = SortingStep(
                        compareIndices: (i, j),
                        shouldSwap: true,
                        resultArray: array,
                        description: "Swap \(array[j]) and \(array[i])",
                        newlySortedIndices: nil
                    )
                    steps.append(swapStep)
                }
            }
        }

        // Place pivot in correct position
        let pivotPosition = i + 1
        if pivotPosition != high {
            array.swapAt(pivotPosition, high)

            let pivotSwapStep = SortingStep(
                compareIndices: (pivotPosition, high),
                shouldSwap: true,
                resultArray: array,
                description: "Place pivot \(pivot) in correct position",
                newlySortedIndices: Set([pivotPosition])
            )
            steps.append(pivotSwapStep)
        } else {
            // Mark pivot as sorted even if no swap
            if !steps.isEmpty {
                let lastStep = steps.removeLast()
                let updatedStep = SortingStep(
                    compareIndices: lastStep.compareIndices,
                    shouldSwap: lastStep.shouldSwap,
                    resultArray: lastStep.resultArray,
                    description: lastStep.description,
                    newlySortedIndices: Set([pivotPosition])
                )
                steps.append(updatedStep)
            }
        }

        return pivotPosition
    }

    func generateRandomArray(count: Int = 5, maxValue: Int = 9) -> [Int] {
        var array: [Int] = []
        var used = Set<Int>()
        while array.count < count {
            let value = Int.random(in: 1...maxValue)
            if !used.contains(value) {
                array.append(value)
                used.insert(value)
            }
        }
        return array
    }
}

// MARK: - App Icon Preview (For Screenshot)

/// Pixel art "W" icon design - Use this for creating app icon asset
/// Screenshot this view at 1024x1024 to create custom app icon
struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Background - Retro dark blue
            AppColors.background

            // Pixel "W" letter
            VStack(spacing: 0) {
                // Row 1
                HStack(spacing: 0) {
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                }

                // Row 2
                HStack(spacing: 0) {
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                }

                // Row 3
                HStack(spacing: 0) {
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.warningOrange)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.warningOrange)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                }

                // Row 4
                HStack(spacing: 0) {
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.warningOrange)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.warningOrange)
                    pixel().foregroundColor(AppColors.primaryBlue)
                }

                // Row 5
                HStack(spacing: 0) {
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(AppColors.successGreen)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.primaryBlue)
                    pixel().foregroundColor(.clear)
                    pixel().foregroundColor(AppColors.successGreen)
                    pixel().foregroundColor(AppColors.primaryBlue)
                }
            }
            .shadow(color: AppColors.pixelShadow, radius: 0, x: 4, y: 4)
        }
        .frame(width: 512, height: 512) // Icon preview size
    }

    private func pixel() -> some View {
        Rectangle()
            .frame(width: 60, height: 60)
            .overlay(
                Rectangle()
                    .strokeBorder(AppColors.pixelBorder, lineWidth: 2)
            )
    }
}

#Preview("App Icon") {
    AppIconPreview()
}

// MARK: - Confetti Animation

/// Confetti celebration effect
struct ConfettiView: View {
    @State private var animate = false
    let colors: [Color] = [
        AppColors.primaryBlue,
        AppColors.successGreen,
        AppColors.warningOrange,
        .purple,
        .pink,
        .yellow
    ]

    var body: some View {
        ZStack {
            ForEach(0..<50, id: \.self) { index in
                ConfettiPiece(color: colors.randomElement() ?? .blue)
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -400...600) : -100
                    )
                    .rotationEffect(.degrees(animate ? Double.random(in: 0...720) : 0))
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: Double.random(in: 1.5...3.0))
                            .delay(Double.random(in: 0...0.3)),
                        value: animate
                    )
            }
        }
        .onAppear {
            animate = true
        }
    }
}

struct ConfettiPiece: View {
    let color: Color
    let shapes = ["circle", "rectangle", "triangle"]

    var body: some View {
        Group {
            switch shapes.randomElement() {
            case "circle":
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
            case "rectangle":
                Rectangle()
                    .fill(color)
                    .frame(width: 8, height: 12)
            default:
                Triangle()
                    .fill(color)
                    .frame(width: 10, height: 10)
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// MARK: - Sound Manager

/// Manages all sound effects for the app using system sounds
/// Provides retro game-style audio feedback for user actions
@MainActor
final class SoundManager {
    static let shared = SoundManager()

    private var isSoundEnabled = true

    private init() {
        // Configure audio session for sound effects
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    /// Play sound for correct answer
    func playCorrect() {
        guard isSoundEnabled else { return }
        // System sound ID 1054 = "Tink" - Perfect for correct answer
        AudioServicesPlaySystemSound(1054)
    }

    /// Play sound for wrong answer
    func playWrong() {
        guard isSoundEnabled else { return }
        // System sound ID 1053 = "Tock" - Good for error/wrong
        AudioServicesPlaySystemSound(1053)
    }

    /// Play sound for swap action
    func playSwap() {
        guard isSoundEnabled else { return }
        // System sound ID 1104 = "Swish" - Perfect for swap movement
        AudioServicesPlaySystemSound(1104)
    }

    /// Play sound for level completion
    func playComplete() {
        guard isSoundEnabled else { return }
        // System sound ID 1025 = "Fanfare" - Victory sound
        AudioServicesPlaySystemSound(1025)
    }

    /// Play sound for button tap
    func playTap() {
        guard isSoundEnabled else { return }
        // System sound ID 1104 = Light tap
        AudioServicesPlaySystemSound(1104)
    }

    /// Play sound for unlock achievement
    func playUnlock() {
        guard isSoundEnabled else { return }
        // System sound ID 1016 = "Suspend" - Achievement sound
        AudioServicesPlaySystemSound(1016)
    }

    /// Toggle sound on/off
    func toggleSound() {
        isSoundEnabled.toggle()
    }

    /// Check if sound is enabled
    var isEnabled: Bool {
        isSoundEnabled
    }
}
