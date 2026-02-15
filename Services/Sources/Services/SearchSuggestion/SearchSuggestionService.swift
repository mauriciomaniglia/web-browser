import Foundation

public protocol SearchSuggestionServiceContract {
    func query(_ url: URL) async throws -> [String]?
}

public final class SearchSuggestionService: SearchSuggestionServiceContract {
    public typealias SearchSuggestionResponse = (_ suggestions: [String]?) -> Void

    private let urlSession = URLSession(configuration: .ephemeral)
    private var task: URLSessionTask?

    public init() {}

    public func query(_ url: URL) async throws -> [String]? {
        let request = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: request)

        return handleResponse(data: data, response: response)
    }

    func handleResponse(data: Data?, response: URLResponse?) -> [String]? {
        guard let data = data,
              let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            return nil
        }

        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

        guard let array = json as? [Any], array.count >= 2 else {
            return nil
        }

        guard let suggestions = array[1] as? [String] else {
            return nil
        }

        return suggestions
    }
}
