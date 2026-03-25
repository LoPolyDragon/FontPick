import Foundation
import SwiftUI
import AppKit

@MainActor
class FontViewModel: ObservableObject {
    @Published var allFonts: [FontInfo] = []
    @Published var filteredFonts: [FontInfo] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: FontCategory = .all
    @Published var previewText: String = "The quick brown fox jumps over the lazy dog"
    @Published var fontSize: Double = 24
    @Published var textColor: Color = .primary
    @Published var backgroundColor: Color = .clear
    @Published var selectedFontsForComparison: [FontInfo] = []
    @Published var showComparison: Bool = false
    @Published var selectedFont: FontInfo?

    init() {
        loadFonts()
    }

    func loadFonts() {
        allFonts = FontLoader.loadAllFonts()
        filterFonts()
    }

    func filterFonts() {
        var result = allFonts

        if selectedCategory != .all {
            result = result.filter { $0.categories.contains(selectedCategory) }
        }

        if !searchText.isEmpty {
            result = result.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.family.localizedCaseInsensitiveContains(searchText) ||
                $0.postScriptName.localizedCaseInsensitiveContains(searchText)
            }
        }

        filteredFonts = result
    }

    func toggleFontForComparison(_ font: FontInfo) {
        if selectedFontsForComparison.contains(font) {
            selectedFontsForComparison.removeAll { $0.id == font.id }
        } else if selectedFontsForComparison.count < 4 {
            selectedFontsForComparison.append(font)
        }
    }

    func isFontSelectedForComparison(_ font: FontInfo) -> Bool {
        selectedFontsForComparison.contains(font)
    }

    func clearComparison() {
        selectedFontsForComparison.removeAll()
    }

    func selectFont(_ font: FontInfo) {
        selectedFont = font
    }
}
