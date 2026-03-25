# Changelog

All notable changes to FontPick will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-25

### Added
- Initial release of FontPick
- Instant preview of all installed system fonts
- Side-by-side comparison of up to 4 fonts
- Font filtering by category (Serif, Sans-Serif, Monospace, Display, Handwriting)
- Font search by name, family, or PostScript name
- Favorites system with star marking
- Custom folder organization for favorites
- Font information panel with detailed metadata
- Copy to clipboard functionality for font names
- Adjustable preview text size (12-72pt)
- Customizable text color and background color
- PNG export of font previews
- Batch export of multiple fonts
- Full dark mode support
- Keyboard shortcuts for common actions
- macOS 14+ compatibility
- App Store ready with sandboxing
- Complete MVVM architecture
- No external dependencies
- Offline functionality

### Technical
- SwiftUI + AppKit implementation
- MVVM design pattern
- UserDefaults for local storage
- Lazy loading for performance
- Full App Sandbox compliance
- Bundle ID: com.lopodragon.fontpick
