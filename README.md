# FontPick

A powerful font preview tool for macOS designers and developers. Browse, compare, and preview all your system fonts instantly.

## Features

### Font Preview
- **Instant Preview**: Type any text and see it rendered in ALL installed system fonts simultaneously
- **Scrollable Grid**: Efficiently browse hundreds of fonts in an organized grid layout
- **Custom Text**: Preview fonts with your own text samples

### Font Comparison
- **Side-by-Side Comparison**: Compare up to 4 fonts simultaneously
- **Quick Selection**: Click the checkbox on any font to add it to comparison
- **Detailed View**: See fonts rendered with identical text for accurate comparison

### Smart Filtering
- **Category Filtering**: Filter fonts by type
  - Serif
  - Sans-Serif
  - Monospace
  - Display
  - Handwriting
- **Search**: Find fonts by name, family, or PostScript name
- **Real-time Updates**: Filtering happens instantly as you type

### Favorites System
- **Star Favorites**: Mark fonts you use frequently with a single click
- **Custom Folders**: Organize favorites into custom folders
- **Drag & Drop**: Easy organization of your favorite fonts

### Font Information
- **Detailed Info Panel**: View comprehensive font information
  - Font name and family
  - PostScript name
  - Available styles (Regular, Bold, Italic, etc.)
  - Categories
- **Copy to Clipboard**: One-click copying of font names for use in your projects

### Customization
- **Adjustable Size**: Preview text from 12pt to 72pt
- **Color Selection**: Choose text color and background color
- **Custom Backgrounds**: Add background colors to better visualize font appearance
- **Live Updates**: All changes reflect immediately across all previews

### Export
- **PNG Export**: Export font previews as high-quality PNG images
- **Batch Export**: Export multiple fonts at once
- **Professional Layout**: Exported images include font names and are formatted for easy sharing

### Dark Mode
- Full native macOS dark mode support
- Automatically adapts to system appearance
- Optimized for both light and dark environments

## Requirements

- macOS 14.0 or later
- No internet connection required
- No external dependencies

## Installation

1. Download FontPick from the Mac App Store
2. Launch the app
3. Start previewing your fonts

## Usage

### Basic Preview
1. The app loads all system fonts automatically
2. Type in the preview text field (default: "The quick brown fox jumps over the lazy dog")
3. All fonts update instantly to show your text

### Comparing Fonts
1. Click the checkbox icon on up to 4 fonts you want to compare
2. Click the "Compare" button in the toolbar
3. View fonts side-by-side with identical formatting

### Organizing Favorites
1. Click the star icon on any font to add it to favorites
2. Create custom folders with the "New Folder" button in Favorites view
3. Use the folder icon on any favorite to add it to a specific folder

### Customizing Preview
1. Click the slider icon in the toolbar to show/hide the customization panel
2. Adjust font size with the slider
3. Select custom text and background colors
4. Clear background for transparent preview

### Exporting Previews
1. Select fonts for comparison OR filter to desired fonts
2. Click "Export" in the toolbar
3. Choose save location
4. PNG image is saved with all selected fonts

## Keyboard Shortcuts

- `⌘C` - Toggle comparison view
- `⌘⇧E` - Export preview as PNG

## Technical Details

- **Architecture**: SwiftUI + AppKit, MVVM pattern
- **Storage**: Local UserDefaults for favorites
- **Performance**: Lazy loading for efficient rendering
- **Sandboxing**: Full App Sandbox compliance

## Bundle ID

`com.lopodragon.fontpick`

## Price

$4.99 USD (One-time purchase)

## Support

For issues or feature requests, please contact support at the app's listing page.

## License

Copyright © 2026 LopoDragon. All rights reserved.

This software is licensed under the MIT License. See LICENSE file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
