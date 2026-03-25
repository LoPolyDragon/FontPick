import SwiftUI
import AppKit

struct CustomizationPanel: View {
    @ObservedObject var viewModel: FontViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Customization")
                .font(.title2)
                .bold()

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Preview Text")
                    .font(.headline)

                TextEditor(text: $viewModel.previewText)
                    .frame(height: 80)
                    .font(.system(size: 12))
                    .border(Color.gray.opacity(0.3), width: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Font Size")
                        .font(.headline)

                    Spacer()

                    Text("\(Int(viewModel.fontSize))pt")
                        .foregroundColor(.secondary)
                }

                Slider(value: $viewModel.fontSize, in: 12...72, step: 1)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Text Color")
                    .font(.headline)

                ColorPicker("", selection: $viewModel.textColor, supportsOpacity: false)
                    .labelsHidden()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Background Color")
                    .font(.headline)

                ColorPicker("", selection: $viewModel.backgroundColor, supportsOpacity: true)
                    .labelsHidden()

                Button("Clear Background") {
                    viewModel.backgroundColor = .clear
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
            }

            Spacer()
        }
        .padding()
        .frame(width: 280)
        .background(Color(nsColor: .controlBackgroundColor))
    }
}
