import Foundation
import SwiftUI
import AppKit

class ExportManager {
    @MainActor
    static func exportToPNG(
        text: String,
        fonts: [FontInfo],
        fontSize: CGFloat,
        textColor: NSColor,
        backgroundColor: NSColor
    ) -> NSImage? {
        let padding: CGFloat = 40
        let spacing: CGFloat = 30
        let titleHeight: CGFloat = 60
        var totalHeight: CGFloat = titleHeight + padding

        var renderedTexts: [(font: FontInfo, image: NSImage)] = []

        for font in fonts {
            guard let nsFont = NSFont(name: font.name, size: fontSize) else { continue }

            let attributes: [NSAttributedString.Key: Any] = [
                .font: nsFont,
                .foregroundColor: textColor
            ]

            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let size = attributedString.size()

            let textImage = NSImage(size: NSSize(width: size.width, height: size.height))
            textImage.lockFocus()
            attributedString.draw(at: .zero)
            textImage.unlockFocus()

            renderedTexts.append((font, textImage))
            totalHeight += size.height + spacing
        }

        let maxWidth = renderedTexts.map { $0.image.size.width }.max() ?? 800
        let canvasWidth = maxWidth + padding * 2
        totalHeight += padding

        let finalImage = NSImage(size: NSSize(width: canvasWidth, height: totalHeight))

        finalImage.lockFocus()

        backgroundColor.setFill()
        NSRect(x: 0, y: 0, width: canvasWidth, height: totalHeight).fill()

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 24, weight: .bold),
            .foregroundColor: textColor
        ]
        let titleString = NSAttributedString(string: "Font Preview Export", attributes: titleAttributes)
        titleString.draw(at: NSPoint(x: padding, y: totalHeight - titleHeight))

        var yOffset = totalHeight - titleHeight - spacing

        for (font, textImage) in renderedTexts {
            let labelAttributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12),
                .foregroundColor: textColor
            ]
            let labelString = NSAttributedString(string: font.displayName, attributes: labelAttributes)
            let labelSize = labelString.size()
            labelString.draw(at: NSPoint(x: padding, y: yOffset - labelSize.height - 5))

            let imageRect = NSRect(
                x: padding,
                y: yOffset - labelSize.height - textImage.size.height - 10,
                width: textImage.size.width,
                height: textImage.size.height
            )
            textImage.draw(in: imageRect)

            yOffset -= (labelSize.height + textImage.size.height + spacing + 10)
        }

        finalImage.unlockFocus()

        return finalImage
    }

    @MainActor
    static func saveImage(_ image: NSImage, panel: NSSavePanel) {
        panel.allowedContentTypes = [.png]
        panel.nameFieldStringValue = "FontPreview.png"

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }

            if let tiffData = image.tiffRepresentation,
               let bitmapImage = NSBitmapImageRep(data: tiffData),
               let pngData = bitmapImage.representation(using: .png, properties: [:]) {
                try? pngData.write(to: url)
            }
        }
    }
}
