import SwiftUI

enum SidebarSelection: Hashable {
    case allFonts
    case favorites
}

struct ContentView: View {
    @EnvironmentObject var viewModel: FontViewModel
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var sidebarSelection: SidebarSelection = .allFonts
    @State private var showInfoPanel = false
    @State private var showCustomizationPanel = true

    var body: some View {
        NavigationSplitView {
            List(selection: $sidebarSelection) {
                Label("All Fonts", systemImage: "textformat")
                    .tag(SidebarSelection.allFonts)

                Label("Favorites", systemImage: "star.fill")
                    .tag(SidebarSelection.favorites)
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200, max: 250)
        } detail: {
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack(spacing: 16) {
                        FontFilterView(viewModel: viewModel)

                        Spacer()

                        HStack(spacing: 8) {
                            Text("\(viewModel.filteredFonts.count) fonts")
                                .foregroundColor(.secondary)

                            Button(action: {
                                if !viewModel.selectedFontsForComparison.isEmpty {
                                    viewModel.showComparison.toggle()
                                }
                            }) {
                                Label("Compare (\(viewModel.selectedFontsForComparison.count))", systemImage: "square.grid.2x2")
                            }
                            .disabled(viewModel.selectedFontsForComparison.isEmpty)

                            Button(action: { exportFonts() }) {
                                Label("Export", systemImage: "square.and.arrow.up")
                            }

                            Button(action: { showCustomizationPanel.toggle() }) {
                                Image(systemName: "slider.horizontal.3")
                            }
                            .help("Customization")
                        }
                    }
                    .padding()
                    .background(Color(nsColor: .windowBackgroundColor))

                    Divider()

                    ZStack {
                        if sidebarSelection == .allFonts {
                            FontGridView(viewModel: viewModel, favoritesManager: favoritesManager)
                        } else {
                            FavoritesView(favoritesManager: favoritesManager, viewModel: viewModel)
                        }
                    }
                }

                if showCustomizationPanel {
                    Divider()
                    CustomizationPanel(viewModel: viewModel)
                }

                if showInfoPanel, let selectedFont = viewModel.selectedFont {
                    Divider()
                    FontInfoPanel(font: selectedFont)
                }
            }
        }
        .frame(minWidth: 600, minHeight: 550)
        .sheet(isPresented: $viewModel.showComparison) {
            FontComparisonView(viewModel: viewModel)
        }
        .onChange(of: viewModel.selectedFont) { newValue in
            showInfoPanel = newValue != nil
        }
    }

    private func exportFonts() {
        let fonts = viewModel.selectedFontsForComparison.isEmpty ?
            Array(viewModel.filteredFonts.prefix(20)) :
            viewModel.selectedFontsForComparison

        let textColor = NSColor(viewModel.textColor)
        let backgroundColor = NSColor(viewModel.backgroundColor)

        if let image = ExportManager.exportToPNG(
            text: viewModel.previewText,
            fonts: fonts,
            fontSize: viewModel.fontSize,
            textColor: textColor,
            backgroundColor: backgroundColor
        ) {
            let panel = NSSavePanel()
            ExportManager.saveImage(image, panel: panel)
        }
    }
}
