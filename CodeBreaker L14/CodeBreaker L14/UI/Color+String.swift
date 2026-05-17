//
//  Color+String.swift
//  CodeBreaker
//
//  Created by ChatGPT on 5/12/25.
//  Prompt: write an extension to iOS Color that converts it back and forth from a string
//  Followup Prompt: extend Color not uicolor
//

import SwiftUI

extension Color {
    /// Initialize a SwiftUI Color from a hex string like "#RRGGBB" or "#RRGGBBAA"
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }

        switch hexSanitized.count {
        case 6: // RRGGBB
            let r = Double((rgb & 0xFF0000) >> 16) / 255
            let g = Double((rgb & 0x00FF00) >> 8) / 255
            let b = Double(rgb & 0x0000FF) / 255
            self.init(red: r, green: g, blue: b)
        case 8: // RRGGBBAA
            let r = Double((rgb & 0xFF000000) >> 24) / 255
            let g = Double((rgb & 0x00FF0000) >> 16) / 255
            let b = Double((rgb & 0x0000FF00) >> 8) / 255
            let a = Double(rgb & 0x000000FF) / 255
            self.init(red: r, green: g, blue: b, opacity: a)
        default:
            return nil
        }
    }

    /// Convert a SwiftUI Color to hex string like "#RRGGBB" or "#RRGGBBAA"
    var hex: String {
        let uiColor = UIColor(self)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        let a = Int(alpha * 255)

        if a < 255 {
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        } else {
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    }
}
