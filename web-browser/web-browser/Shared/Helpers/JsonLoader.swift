import Foundation

public final class JsonLoader {
    public static func loadJsonContent(filename: String) -> String? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else { return nil }

        do {
            let data = try Data(contentsOf: url)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
