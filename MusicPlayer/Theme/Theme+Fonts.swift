//
//  Theme+Fonts.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import UIKit
import SwiftUI

public class Fonts {

    public enum FontStyle: String {
        case regular = "GoogleSans-Regular"
        case medium = "GoogleSans-Medium"
        case bold = "GoogleSans-Bold"
        case italic = "GoogleSans-Italic"
        case mediumItalic = "GoogleSans-MediumItalic"
        case boldItalic = "GoogleSans-BoldItalic"
        case flex = "GoogleSansFlex"
    }

    /// Get a UIFont with the specified style and size
    /// - Parameters:
    ///   - style: The font style to use
    ///   - size: The point size for the font
    /// - Returns: A UIFont instance, or system font if custom font fails to load
    static func uiFont(_ style: FontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    /// Get a SwiftUI Font with the specified style and size
    /// - Parameters:
    ///   - style: The font style to use
    ///   - size: The point size for the font
    /// - Returns: A SwiftUI Font instance, or system font if custom font fails to load
    static func font(_ style: FontStyle, size: CGFloat) -> Font {
        if let uiFont = UIFont(name: style.rawValue, size: size) {
            return Font(uiFont)
        }
        return Font.system(size: size)
    }

    // MARK: - Convenience Properties

    /// Regular font variants
    public enum Regular {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.regular, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.regular, size: size)
        }
    }

    /// Medium font variants
    public enum Medium {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.medium, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.medium, size: size)
        }
    }

    /// Bold font variants
    public enum Bold {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.bold, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.bold, size: size)
        }
    }

    /// Italic font variants
    public enum Italic {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.italic, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.italic, size: size)
        }
    }

    /// Medium Italic font variants
    public enum MediumItalic {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.mediumItalic, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.mediumItalic, size: size)
        }
    }

    /// Bold Italic font variants
    public enum BoldItalic {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.boldItalic, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.boldItalic, size: size)
        }
    }

    /// Flex font variants
    public enum Flex {
        static func size(_ size: CGFloat) -> Font {
            return Fonts.font(.flex, size: size)
        }

        static func uiFont(_ size: CGFloat) -> UIFont {
            return Fonts.uiFont(.flex, size: size)
        }
    }
}
