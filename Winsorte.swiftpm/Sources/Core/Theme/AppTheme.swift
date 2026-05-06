import SwiftUI

/// Main theme configuration combining colors, typography, and layout constants
/// PIXEL ART / RETRO GAME aesthetic with square shapes and thick borders
enum AppTheme {

    // MARK: - Spacing (Grid-based for pixel perfection)

    /// Extra small spacing (4pt) - Pixel unit
    static let spacingXS: CGFloat = 4

    /// Small spacing (8pt) - 2 pixel units
    static let spacingS: CGFloat = 8

    /// Medium spacing (12pt) - 3 pixel units
    static let spacingM: CGFloat = 12

    /// Default spacing (16pt) - 4 pixel units
    static let spacing: CGFloat = 16

    /// Large spacing (24pt) - 6 pixel units
    static let spacingL: CGFloat = 24

    /// Extra large spacing (32pt) - 8 pixel units
    static let spacingXL: CGFloat = 32

    /// Extra extra large spacing (48pt) - 12 pixel units
    static let spacingXXL: CGFloat = 48

    // MARK: - Corner Radius (Minimal - Pixel Art Style)

    /// No corners - Square pixel style (0pt)
    static let cornerRadiusS: CGFloat = 0

    /// Minimal corner - Slight softening (2pt)
    static let cornerRadius: CGFloat = 2

    /// Small corner - For larger elements (4pt)
    static let cornerRadiusM: CGFloat = 4

    /// Medium corner - Maximum rounding allowed (6pt)
    static let cornerRadiusL: CGFloat = 6

    /// Large corner - Reserved for special cases (8pt)
    static let cornerRadiusXL: CGFloat = 8

    // MARK: - Borders (Thick Pixel Style)

    /// Thin border for details (2pt)
    static let borderThin: CGFloat = 2

    /// Standard border for most elements (3pt)
    static let borderStandard: CGFloat = 3

    /// Thick border for emphasis (4pt)
    static let borderThick: CGFloat = 4

    /// Extra thick border for major elements (6pt)
    static let borderExtraThick: CGFloat = 6

    static var shadowLight: Shadow {
        Shadow(color: AppColors.pixelShadow.opacity(0.4), radius: 0, x: 2, y: 2)
    }

    static var shadowMedium: Shadow {
        Shadow(color: AppColors.pixelShadow.opacity(0.6), radius: 0, x: 4, y: 4)
    }

    static var shadowStrong: Shadow {
        Shadow(color: AppColors.pixelShadow.opacity(0.8), radius: 0, x: 6, y: 6)
    }

    static let animationDuration: Double = 0.15
    static let animationQuick: Double = 0.1
    static let animationSlow: Double = 0.25

    static func pixelAnimation(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : .linear(duration: animationDuration)
    }

    static func pixelQuick(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : .linear(duration: animationQuick)
    }

    static func pixelSlow(reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : .linear(duration: animationSlow)
    }

    static var pixelAnimation: Animation {
        .linear(duration: animationDuration)
    }

    static var pixelQuick: Animation {
        .linear(duration: animationQuick)
    }

    static var pixelSlow: Animation {
        .linear(duration: animationSlow)
    }

    static var easeInOut: Animation {
        .easeInOut(duration: animationDuration)
    }

    static var springAnimation: Animation {
        .linear(duration: animationDuration)
    }

    // MARK: - Layout

    /// Minimum touch target size (44pt - iOS HIG)
    static let minTouchTarget: CGFloat = 44

    /// Standard button height
    static let buttonHeight: CGFloat = 50

    /// Large button height
    static let buttonHeightLarge: CGFloat = 56

    /// Card padding
    static let cardPadding: CGFloat = spacing

    /// Screen horizontal padding
    static let screenPadding: CGFloat = spacingL
}

// MARK: - Shadow Model

/// Shadow configuration
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions

extension View {
    /// Applies app's light shadow
    func appShadowLight() -> some View {
        shadow(
            color: AppTheme.shadowLight.color,
            radius: AppTheme.shadowLight.radius,
            x: AppTheme.shadowLight.x,
            y: AppTheme.shadowLight.y
        )
    }

    /// Applies app's medium shadow
    func appShadowMedium() -> some View {
        shadow(
            color: AppTheme.shadowMedium.color,
            radius: AppTheme.shadowMedium.radius,
            x: AppTheme.shadowMedium.x,
            y: AppTheme.shadowMedium.y
        )
    }

    /// Applies app's strong shadow
    func appShadowStrong() -> some View {
        shadow(
            color: AppTheme.shadowStrong.color,
            radius: AppTheme.shadowStrong.radius,
            x: AppTheme.shadowStrong.x,
            y: AppTheme.shadowStrong.y
        )
    }

    /// Applies pixel-style card with thick border
    func cardStyle() -> some View {
        self
            .background(AppColors.cardBackground)
            .cornerRadius(AppTheme.cornerRadiusM)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadiusM)
                    .stroke(AppColors.pixelBorder, lineWidth: AppTheme.borderStandard)
            )
            .appShadowMedium()
    }

    /// Applies pixel-style primary button with thick border
    func primaryButtonStyle() -> some View {
        self
            .font(.appButton)
            .foregroundColor(.white)
            .frame(height: AppTheme.buttonHeight)
            .frame(maxWidth: .infinity)
            .background(AppColors.primaryBlue)
            .cornerRadius(AppTheme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppColors.pixelBorder, lineWidth: AppTheme.borderStandard)
            )
            .appShadowMedium()
    }

    /// Applies pixel border to any view
    func pixelBorder(width: CGFloat = AppTheme.borderStandard, color: Color = AppColors.pixelBorder) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                .stroke(color, lineWidth: width)
        )
    }

    /// Applies thick pixel border for emphasis
    func pixelBorderThick(color: Color = AppColors.pixelBorder) -> some View {
        self.pixelBorder(width: AppTheme.borderThick, color: color)
    }
}
