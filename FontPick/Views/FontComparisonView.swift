import SwiftUI

struct FontComparisonView: View {
    @ObservedObject var viewModel: FontViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Font Comparison")
                    .font(.title2)
                    .bold()

                Spacer()

                Button("Clear All") {
                    viewModel.clearComparison()
                }
                .disabled(viewModel.selectedFontsForComparison.isEmpty)

                Button("Close") {
                    viewModel.showComparison = false
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            if viewModel.selectedFontsForComparison.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "square.grid.2x2")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)

                    Text("No fonts selected for comparison")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Select up to 4 fonts from the grid to compare them side by side")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.selectedFontsForComparison) { font in
                            ComparisonCard(
                                font: font,
                                previewText: viewModel.previewText,
                                fontSize: viewModel.fontSize,
                                textColor: viewModel.textColor,
                                backgroundColor: viewModel.backgroundColor,
                                onRemove: {
                                    viewModel.toggleFontForComparison(font)
                                }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(minWidth: 600, minHeight: 400)
    }
}

struct ComparisonCard: View {
    let font: FontInfo
    let previewText: String
    let fontSize: Double
    let textColor: Color
    let backgroundColor: Color
    let onRemove: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(font.displayName)
                        .font(.title3)
                        .bold()

                    Text(font.postScriptName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .buttonStyle(.plain)
            }

            Divider()

            Text(previewText)
                .font(.custom(font.name, size: fontSize))
                .foregroundColor(textColor)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(backgroundColor)
                .cornerRadius(6)
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
