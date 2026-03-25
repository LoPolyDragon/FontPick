import Foundation

@MainActor
class FavoritesManager: ObservableObject {
    @Published var folders: [FavoriteFolder] = []
    @Published var favoriteFontNames: Set<String> = []

    private let foldersKey = "favoriteFolders"
    private let favoritesKey = "favoriteFonts"

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: foldersKey),
           let decoded = try? JSONDecoder().decode([FavoriteFolder].self, from: data) {
            folders = decoded
        }

        if let savedFavorites = UserDefaults.standard.array(forKey: favoritesKey) as? [String] {
            favoriteFontNames = Set(savedFavorites)
        }
    }

    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encoded, forKey: foldersKey)
        }
        UserDefaults.standard.set(Array(favoriteFontNames), forKey: favoritesKey)
    }

    func toggleFavorite(fontName: String) {
        if favoriteFontNames.contains(fontName) {
            favoriteFontNames.remove(fontName)
            for index in folders.indices {
                folders[index].fontNames.removeAll { $0 == fontName }
            }
        } else {
            favoriteFontNames.insert(fontName)
        }
        saveFavorites()
    }

    func isFavorite(fontName: String) -> Bool {
        favoriteFontNames.contains(fontName)
    }

    func createFolder(name: String) {
        let folder = FavoriteFolder(name: name)
        folders.append(folder)
        saveFavorites()
    }

    func deleteFolder(id: UUID) {
        folders.removeAll { $0.id == id }
        saveFavorites()
    }

    func renameFolder(id: UUID, newName: String) {
        if let index = folders.firstIndex(where: { $0.id == id }) {
            folders[index].name = newName
            saveFavorites()
        }
    }

    func addFontToFolder(fontName: String, folderId: UUID) {
        if let index = folders.firstIndex(where: { $0.id == folderId }) {
            if !folders[index].fontNames.contains(fontName) {
                folders[index].fontNames.append(fontName)
                favoriteFontNames.insert(fontName)
                saveFavorites()
            }
        }
    }

    func removeFontFromFolder(fontName: String, folderId: UUID) {
        if let index = folders.firstIndex(where: { $0.id == folderId }) {
            folders[index].fontNames.removeAll { $0 == fontName }
            saveFavorites()
        }
    }

    func getFontsInFolder(folderId: UUID) -> [String] {
        folders.first { $0.id == folderId }?.fontNames ?? []
    }
}
