import SwiftUI

enum AppTypography {

    static var largeTitle: Font {
        .system(.largeTitle, design: .monospaced, weight: .black)
    }

    static var title: Font {
        .system(.title, design: .monospaced, weight: .bold)
    }

    static var title2: Font {
        .system(.title2, design: .monospaced, weight: .bold)
    }

    static var title3: Font {
        .system(.title3, design: .monospaced, weight: .semibold)
    }

    static var body: Font {
        .system(.body, design: .monospaced, weight: .medium)
    }

    static var bodyBold: Font {
        .system(.body, design: .monospaced, weight: .bold)
    }

    static var callout: Font {
        .system(.callout, design: .monospaced, weight: .regular)
    }

    static var button: Font {
        .system(.body, design: .monospaced, weight: .bold)
    }

    static var caption: Font {
        .system(.caption, design: .monospaced, weight: .regular)
    }

    static var caption2: Font {
        .system(.caption2, design: .monospaced, weight: .regular)
    }

    static var arrayNumber: Font {
        .system(.title, design: .monospaced, weight: .black)
    }

    static var gameStats: Font {
        .system(.subheadline, design: .monospaced, weight: .bold)
    }

    static var largeNumber: Font {
        .system(.largeTitle, design: .monospaced, weight: .black)
    }
}

// MARK: - SwiftUI Font Extensions

extension Font {
    /// App's large title font
    static var appLargeTitle: Font { AppTypography.largeTitle }

    /// App's title font
    static var appTitle: Font { AppTypography.title }

    /// App's title2 font
    static var appTitle2: Font { AppTypography.title2 }

    /// App's title3 font
    static var appTitle3: Font { AppTypography.title3 }

    /// App's body font
    static var appBody: Font { AppTypography.body }

    /// App's bold body font
    static var appBodyBold: Font { AppTypography.bodyBold }

    /// App's callout font
    static var appCallout: Font { AppTypography.callout }

    /// App's button font
    static var appButton: Font { AppTypography.button }

    /// App's caption font
    static var appCaption: Font { AppTypography.caption }

    /// App's array number font
    static var appArrayNumber: Font { AppTypography.arrayNumber }

    /// App's game stats font
    static var appGameStats: Font { AppTypography.gameStats }
}
