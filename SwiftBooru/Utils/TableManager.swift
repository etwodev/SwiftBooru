import Foundation

class DictionaryFileManager<T: Codable & Identifiable> {
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let documentsDirectory: URL
    private let unsafeChars = CharacterSet(charactersIn: "\"#%/:<>?\\^{|}")
    
    let tableIdentifier: String
    
    init(identifier: String) {
        documentsDirectory = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        tableIdentifier = identifier.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: unsafeChars)
            .joined(separator: "")
    }
    
    private func fileName(for structValue: T) -> String {
        let structName = String(describing: type(of: structValue))
        return "\(structName).json"
    }
    
    private func filePath(for structValue: T) -> URL {
        let fileName = self.fileName(for: structValue)
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func readDictionary(for structValue: T) throws -> [String: T]? {
        let filePath = self.filePath(for: structValue)
        
        guard fileManager.fileExists(atPath: filePath.path) else {
            return nil
        }
        
        let data = try Data(contentsOf: filePath)
        return try decoder.decode([String: T].self, from: data)
    }
    
    func writeDictionary(_ dictionary: [String: T], for structValue: T) throws {
        let filePath = self.filePath(for: structValue)
        let data = try encoder.encode(dictionary)
        
        try fileManager.createDirectory(at: documentsDirectory, withIntermediateDirectories: true, attributes: nil)
        fileManager.createFile(atPath: filePath.path, contents: data, attributes: nil)
    }
    
    func addValue(_ value: T, to structValue: T) throws {
        var dictionary = try readDictionary(for: structValue) ?? [String: T]()
        dictionary[structValue.id as! String] = value
        try writeDictionary(dictionary, for: structValue)
    }
}
