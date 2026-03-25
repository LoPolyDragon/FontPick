import SwiftUI
import AppKit

struct FontInfoPanel: View {
    let font: FontInfo
    @State private var copiedField: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Font Information")
                .font(.title2)
                .bold()

            Divider()

            InfoRow(title: "Name", value: font.displayName, onCopy: {
                copyToClipboard(font.displayName)
                copiedField = "name"
            }, isCopied: copiedField == "name")

            InfoRow(title: "Family", value: font.family, onCopy: {
                copyToClipboard(font.family)
                copiedField = "family"
            }, isCopied: copiedField == "family")

            InfoRow(title: "PostScript Name", value: font.postScriptName, onCopy: {
                copyToClipboard(font.postScriptName)
                copiedField = "postscript"
            }, isCopied: copiedField == "postscript")

            VStack(alignment: .leading, spacing: 8) {
                Text("Available Styles")
                    .font(.headline)

                if font.availableStyles.isEmpty {
                    Text("Regular")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(font.availableStyles, id: \.self) { style in
                        Text("• \(style)")
                            .foregroundColor(.secondary)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Categories")
                    .font(.headline)

                HStack(spacing: 8) {
                    ForEach(font.categories.filter { $0 != .all }, id: \.self) { category in
                        Text(category.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.2))
                            .foregroundColor(.accentColor)
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .frame(width: 300)
        .background(Color(nsColor: .controlBackgroundColor))
    }

    private func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedField = nil
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    let onCopy: () -> Void
    let isCopied: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.headline)

                Spacer()

                Button(action: onCopy) {
                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        .foregroundColor(isCopied ? .green : .accentColor)
                }
                .buttonStyle(.plain)
            }

            Text(value)
                .foregroundColor(.secondary)
                .textSelection(.enabled)
        }
    }
}
