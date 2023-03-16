import Foundation

class DatabaseManager {
    let fileManager = FileManager.default
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    init() {
        createDirectoryIfNeeded()
    }
    
    func save<T: Codable>(_ data: T, to fileName: String) throws {
        let url = try makeFileURL(with: fileName)
        let encodedData = try encoder.encode(data)
        try encodedData.write(to: url)
    }

    func load<T: Codable>(from fileName: String) throws -> T {
        let url = try makeFileURL(with: fileName)
        let data = try Data(contentsOf: url)
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
    
    private func createDirectoryIfNeeded() {
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderUrl = url.appendingPathComponent("Database", isDirectory: true)
        if !fileManager.fileExists(atPath: folderUrl.path) {
            try? fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }

    private func makeFileURL(with fileName: String) throws -> URL {
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let folderUrl = url.appendingPathComponent("Database", isDirectory: true)
        let fileUrl = folderUrl.appendingPathComponent(fileName)
        return fileUrl
    }
}
