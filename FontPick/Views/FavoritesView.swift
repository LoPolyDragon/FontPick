import SwiftUI

struct FavoritesView: View {
    @ObservedObject var favoritesManager: FavoritesManager
    @ObservedObject var viewModel: FontViewModel
    @State private var showNewFolderSheet = false
    @State private var newFolderName = ""
    @State private var selectedFolder: FavoriteFolder?

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Favorites")
                    .font(.title2)
                    .bold()

                Spacer()

                Button(action: { showNewFolderSheet = true }) {
                    Label("New Folder", systemImage: "folder.badge.plus")
                }
            }
            .padding()
            .background(Color(nsColor: .controlBackgroundColor))

            Divider()

            if favoritesManager.favoriteFontNames.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "star")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)

                    Text("No favorite fonts yet")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    Text("Click the star icon on any font to add it to your favorites")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("All Favorites")
                                .font(.headline)

                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.allFonts.filter { favoritesManager.isFavorite(fontName: $0.name) }) { font in
                                    FavoriteFontRow(
                                        font: font,
                                        onRemove: {
                                            favoritesManager.toggleFavorite(fontName: font.name)
                                        },
                                        onAddToFolder: { folder in
                                            favoritesManager.addFontToFolder(fontName: font.name, folderId: folder.id)
                                        },
                                        folders: favoritesManager.folders
                                    )
                                }
                            }
                        }

                        if !favoritesManager.folders.isEmpty {
                            Divider()

                            Text("Folders")
                                .font(.headline)

                            ForEach(favoritesManager.folders) { folder in
                                FolderSection(
                                    folder: folder,
                                    fonts: viewModel.allFonts.filter { folder.fontNames.contains($0.name) },
                                    onDeleteFolder: {
                                        favoritesManager.deleteFolder(id: folder.id)
                                    },
                                    onRemoveFont: { fontName in
                                        favoritesManager.removeFontFromFolder(fontName: fontName, folderId: folder.id)
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showNewFolderSheet) {
            VStack(spacing: 20) {
                Text("Create New Folder")
                    .font(.title2)
                    .bold()

                TextField("Folder name", text: $newFolderName)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        showNewFolderSheet = false
                        newFolderName = ""
                    }

                    Button("Create") {
                        if !newFolderName.isEmpty {
                            favoritesManager.createFolder(name: newFolderName)
                            showNewFolderSheet = false
                            newFolderName = ""
                        }
                    }
                    .disabled(newFolderName.isEmpty)
                }
            }
            .padding()
            .frame(width: 300, height: 150)
        }
    }
}

struct FavoriteFontRow: View {
    let font: FontInfo
    let onRemove: () -> Void
    let onAddToFolder: (FavoriteFolder) -> Void
    let folders: [FavoriteFolder]

    var body: some View {
        HStack {
            Text(font.displayName)

            Spacer()

            if !folders.isEmpty {
                Menu {
                    ForEach(folders) { folder in
                        Button(folder.name) {
                            onAddToFolder(folder)
                        }
                    }
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
                .menuStyle(.borderlessButton)
            }

            Button(action: onRemove) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(6)
    }
}

struct FolderSection: View {
    let folder: FavoriteFolder
    let fonts: [FontInfo]
    let onDeleteFolder: () -> Void
    let onRemoveFont: (String) -> Void
    @State private var isExpanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                }
                .buttonStyle(.plain)

                Image(systemName: "folder.fill")
                    .foregroundColor(.accentColor)

                Text(folder.name)
                    .font(.headline)

                Text("(\(fonts.count))")
                    .foregroundColor(.secondary)

                Spacer()

                Button(action: onDeleteFolder) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
            }

            if isExpanded {
                VStack(spacing: 4) {
                    ForEach(fonts) { font in
                        HStack {
                            Text(font.displayName)
                                .padding(.leading, 24)

                            Spacer()

                            Button(action: { onRemoveFont(font.name) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(6)
                        .background(Color(nsColor: .controlBackgroundColor).opacity(0.5))
                        .cornerRadius(4)
                    }
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(8)
    }
}
