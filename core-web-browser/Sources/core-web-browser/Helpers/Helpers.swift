import Foundation

public final class Helpers {
    public static func loadJsonContent(filename: String) -> String? {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else { return nil }

        do {
            let data = try Data(contentsOf: url)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
