import Foundation

class DictionaryFileManager<T: Codable & Identifiable> {
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let unsafeChars = CharacterSet(charactersIn: "\"#%/:<>?\\^{|}")
    
    private let filePath: URL
    private let tableIdentifier: String
    private let documentsDirectory: URL

    
    init(identifier: String) {
        documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        tableIdentifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: unsafeChars)
            .joined(separator: "")
        filePath = documentsDirectory.appendingPathComponent("\(String(describing: type(of: T.self)))-\(tableIdentifier).json")
    }

    func readDictionary() throws -> [String: T]? {
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        let data = try Data(contentsOf: filePath)
        return try decoder.decode([String: T].self, from: data)
    }
    
    func writeDictionary(_ dictionary: [String: T]) throws {
        let data = try encoder.encode(dictionary)
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        fileManager.createFile(atPath: filePath.path, contents: data, attributes: nil)
    }
    
    func addValue(_ value: T) throws {
        var dictionary = try readDictionary() ?? [String: T]()
        dictionary[value.id as! String] = value
        try writeDictionary(dictionary)
    }
    
    func exists(_ value: T) -> Bool {
        guard let dictionary = try? readDictionary() else {
            return false
        }
        return dictionary[value.id as! String] != nil
    }
}
