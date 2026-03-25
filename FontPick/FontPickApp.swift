import SwiftUI

@main
struct FontPickApp: App {
    @StateObject private var viewModel = FontViewModel()
    @StateObject private var favoritesManager = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environmentObject(favoritesManager)
                .frame(minWidth: 900, minHeight: 600)
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Export Preview as PNG...") {
                    exportCurrentView()
                }
                .keyboardShortcut("e", modifiers: [.command, .shift])
            }

            CommandGroup(replacing: .sidebar) {
                Button("Toggle Comparison View") {
                    viewModel.showComparison.toggle()
                }
                .keyboardShortcut("c", modifiers: [.command])
                .disabled(viewModel.selectedFontsForComparison.isEmpty)
            }
        }
    }

    private func exportCurrentView() {
        let fonts = viewModel.filteredFonts.isEmpty ? viewModel.allFonts : viewModel.filteredFonts
        let textColor = NSColor(viewModel.textColor)
        let backgroundColor = NSColor(viewModel.backgroundColor)

        if let image = ExportManager.exportToPNG(
            text: viewModel.previewText,
            fonts: Array(fonts.prefix(20)),
            fontSize: viewModel.fontSize,
            textColor: textColor,
            backgroundColor: backgroundColor
        ) {
            let panel = NSSavePanel()
            ExportManager.saveImage(image, panel: panel)
        }
    }
}
