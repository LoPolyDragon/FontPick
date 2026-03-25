import Foundation
import AppKit

struct FontInfo: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let displayName: String
    let family: String
    let postScriptName: String
    let availableStyles: [String]
    let categories: [FontCategory]

    static func == (lhs: FontInfo, rhs: FontInfo) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

struct FavoriteFolder: Identifiable, Codable {
    let id: UUID
    var name: String
    var fontNames: [String]

    init(id: UUID = UUID(), name: String, fontNames: [String] = []) {
        self.id = id
        self.name = name
        self.fontNames = fontNames
    }
}

class FontLoader {
    static func loadAllFonts() -> [FontInfo] {
        let fontManager = NSFontManager.shared
        let families = fontManager.availableFontFamilies
        var fonts: [FontInfo] = []

        for family in families {
            guard let members = fontManager.availableMembers(ofFontFamily: family) else { continue }

            var styles: [String] = []
            var primaryFontName: String?

            for member in members {
                if let fontName = member[0] as? String {
                    if primaryFontName == nil {
                        primaryFontName = fontName
                    }
                    if let styleName = member[1] as? String {
                        styles.append(styleName)
                    }
                }
            }

            if let fontName = primaryFontName {
                let postScriptName = NSFont(name: fontName, size: 12)?.fontName ?? fontName
                let categories = FontCategory.categorize(fontName: fontName)

                let fontInfo = FontInfo(
                    name: fontName,
                    displayName: family,
                    family: family,
                    postScriptName: postScriptName,
                    availableStyles: styles,
                    categories: categories
                )
                fonts.append(fontInfo)
            }
        }

        return fonts.sorted { $0.displayName < $1.displayName }
    }
}
