import Foundation

enum FontCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case serif = "Serif"
    case sansSerif = "Sans-Serif"
    case monospace = "Monospace"
    case display = "Display"
    case handwriting = "Handwriting"

    var id: String { rawValue }

    static func categorize(fontName: String) -> [FontCategory] {
        let lowerName = fontName.lowercased()
        var categories: [FontCategory] = [.all]

        if lowerName.contains("mono") || lowerName.contains("courier") || lowerName.contains("console") {
            categories.append(.monospace)
        } else if lowerName.contains("script") || lowerName.contains("brush") || lowerName.contains("handwriting") ||
                  lowerName.contains("signature") || lowerName.contains("marker") {
            categories.append(.handwriting)
        } else if lowerName.contains("display") || lowerName.contains("poster") || lowerName.contains("headline") ||
                  lowerName.contains("impact") || lowerName.contains("stencil") {
            categories.append(.display)
        } else if lowerName.contains("times") || lowerName.contains("garamond") || lowerName.contains("baskerville") ||
                  lowerName.contains("didot") || lowerName.contains("serif") {
            categories.append(.serif)
        } else {
            categories.append(.sansSerif)
        }

        return categories
    }
}
