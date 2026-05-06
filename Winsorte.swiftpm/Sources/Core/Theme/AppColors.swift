import SwiftUI

enum AppColors {

    static var primaryBlue: Color {
        Color(.primary(light: (63, 186, 255), dark: (100, 200, 255)))
    }

    static var successGreen: Color {
        Color(.success(light: (0, 228, 54), dark: (50, 240, 100)))
    }

    static var errorRed: Color {
        Color(.error(light: (255, 0, 77), dark: (255, 70, 120)))
    }

    static var warningOrange: Color {
        Color(.warning(light: (255, 197, 58), dark: (255, 210, 100)))
    }

    static var pixelPurple: Color {
        Color(.accent(light: (192, 101, 255), dark: (210, 140, 255)))
    }

    static var background: Color {
        Color(.background(light: (240, 242, 247), dark: (26, 28, 44)))
    }

    static var cardBackground: Color {
        Color(.cardBackground(light: (255, 255, 255), dark: (41, 54, 111)))
    }

    static var textPrimary: Color {
        Color(.textPrimary(light: (28, 28, 30), dark: (244, 244, 244)))
    }

    static var textSecondary: Color {
        Color(.textSecondary(light: (142, 142, 147), dark: (166, 166, 191)))
    }

    static var comparison: Color {
        warningOrange
    }

    static var sorted: Color {
        successGreen
    }

    static var unsorted: Color {
        Color(.unsorted(light: (209, 209, 214), dark: (26, 28, 44)))
    }

    static var correctOverlay: Color {
        successGreen.opacity(0.2)
    }

    static var wrongOverlay: Color {
        errorRed.opacity(0.2)
    }

    static var pixelShadow: Color {
        Color(.shadow(light: (13, 13, 20), dark: (13, 13, 20)))
    }

    static var pixelBorder: Color {
        Color(.border(light: (174, 174, 178), dark: (20, 23, 36)))
    }

    static var pixelHighlight: Color {
        Color(.highlight(light: (102, 102, 128), dark: (102, 102, 128)))
    }
}

private extension UIColor {
    static func primary(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func success(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func error(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func warning(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func accent(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func background(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func cardBackground(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func textPrimary(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func textSecondary(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func unsorted(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func shadow(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func border(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }

    static func highlight(light: (Int, Int, Int), dark: (Int, Int, Int)) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(red: CGFloat(dark.0)/255, green: CGFloat(dark.1)/255, blue: CGFloat(dark.2)/255, alpha: 1)
            : UIColor(red: CGFloat(light.0)/255, green: CGFloat(light.1)/255, blue: CGFloat(light.2)/255, alpha: 1)
        }
    }
}

extension Color {
    static var appPrimary: Color { AppColors.primaryBlue }
    static var appSuccess: Color { AppColors.successGreen }
    static var appError: Color { AppColors.errorRed }
    static var appWarning: Color { AppColors.warningOrange }
    static var appBackground: Color { AppColors.background }
    static var appCardBackground: Color { AppColors.cardBackground }
}
