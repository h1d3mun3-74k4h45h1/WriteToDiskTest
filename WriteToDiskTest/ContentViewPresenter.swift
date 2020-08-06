import Foundation

protocol ContentViewPresenterProtocol {
    func save(key: String, value: String)
    func restore() -> [String: String]
    func delete()
}

struct ContentViewPresenter {

}

extension ContentViewPresenter {
    private func getFilePath() -> String {
        let array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard var cacheRoot = array.first else { return "" }
        cacheRoot.append("ContentViewModel")

        return cacheRoot
    }
}

extension ContentViewPresenter: ContentViewPresenterProtocol {
    func save(key: String, value: String) {

        let model = ContentViewModel()
        model.update(key: key, value: value)

        NSKeyedArchiver.archiveRootObject(model, toFile: getFilePath())
    }

    func restore() -> [String: String] {
        let fileManager = FileManager.default

        guard fileManager.fileExists(atPath: getFilePath()),
            let result = NSKeyedUnarchiver.unarchiveObject(withFile: getFilePath()) as? ContentViewModel else {
                return [:]
        }

        return result.valueDictionary
    }

    func delete() {
        do {
            try? FileManager.default.removeItem(atPath: getFilePath())
        } catch {
            
        }
    }
}
