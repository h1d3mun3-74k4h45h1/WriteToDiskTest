import Foundation

 final class ContentViewModel: NSObject, NSCoding {
    var valueDictionary = [String: String]()

     override init() {
    }

     func encode(with coder: NSCoder) {
        coder.encode(valueDictionary, forKey: "valueDictionary")
    }

     init?(coder: NSCoder) {
        if let t = coder.decodeObject(forKey: "valueDictionary") as? [String: String] {
            valueDictionary = t
        }
    }

    func update(key: String, value: String) {
        valueDictionary = [String: String]()
        valueDictionary[key] = value
    }
}
