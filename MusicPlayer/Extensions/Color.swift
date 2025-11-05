//
//  Color.swift
//  MusicPlayer
//
//  Created by Winston Du on 11/4/25.
//
import Foundation
import UIKit
import SwiftUI

extension UIColor {
    /// Parses a sanitized 6-digit hex string (RRGGBB) into normalized RGB components.
    /// - Parameter hexSanitized: Hex string without leading '#', must be exactly 6 characters.
    /// - Returns: Tuple of (red, green, blue) in 0.0...1.0 if parsing succeeds; otherwise nil.
    private static func rgbComponents(fromSixDigitHex hexSanitized: String) -> (
        red: Double, green: Double, blue: Double
    )? {
        guard hexSanitized.count == 6 else { return nil }
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        return (red, green, blue)
    }
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // Remove hash if it exists
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        guard let (red, green, blue) = Self.rgbComponents(fromSixDigitHex: hexSanitized) else {
            return nil
        }
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0)
    }
}

extension Color {
    public init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else {
            return nil
        }
        self.init(uiColor: uiColor)
    }
}

