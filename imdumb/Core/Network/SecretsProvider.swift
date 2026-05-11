import Foundation

protocol SecretsProviding {
    func value(forKey key: String) -> String?
}

struct PlistSecretsProvider: SecretsProviding {

    private static var defaultPlistName: String {
        #if DEV
        return "Secrets-Dev"
        #else
        return "Secrets-Prod"
        #endif
    }

    private let dictionary: [String: Any]

    init(plistName: String = Self.defaultPlistName) {
        guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let dict = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any] else {
            fatalError("Missing \(plistName).plist in bundle")
        }
        self.dictionary = dict
    }

    func value(forKey key: String) -> String? {
        dictionary[key] as? String
    }
}
