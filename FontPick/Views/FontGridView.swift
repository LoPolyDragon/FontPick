import SwiftUI
import AppKit

struct FontGridView: View {
    @ObservedObject var viewModel: FontViewModel
    @ObservedObject var favoritesManager: FavoritesManager

    let columns = [
        GridItem(.adaptive(minimum: 400, maximum: .infinity), spacing: 20)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredFonts) { font in
                    FontPreviewCard(
                        font: font,
                        previewText: viewModel.previewText,
                        fontSize: viewModel.fontSize,
                        textColor: viewModel.textColor,
                        backgroundColor: viewModel.backgroundColor,
                        isFavorite: favoritesManager.isFavorite(fontName: font.name),
                        isSelectedForComparison: viewModel.isFontSelectedForComparison(font),
                        onTap: { viewModel.selectFont(font) },
                        onToggleFavorite: { favoritesManager.toggleFavorite(fontName: font.name) },
                        onToggleComparison: { viewModel.toggleFontForComparison(font) }
                    )
                }
            }
            .padding()
        }
    }
}

struct FontPreviewCard: View {
    let font: FontInfo
    let previewText: String
    let fontSize: Double
    let textColor: Color
    let backgroundColor: Color
    let isFavorite: Bool
    let isSelectedForComparison: Bool
    let onTap: () -> Void
    let onToggleFavorite: () -> Void
    let onToggleComparison: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(font.displayName)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)

                Button(action: onToggleComparison) {
                    Image(systemName: isSelectedForComparison ? "checkmark.square.fill" : "square")
                        .foregroundColor(isSelectedForComparison ? .accentColor : .gray)
                }
                .buttonStyle(.plain)
            }

            Text(previewText)
                .font(.custom(font.name, size: fontSize))
                .foregroundColor(textColor)
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .cornerRadius(4)
                .lineLimit(3)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            onTap()
        }
    }
}
