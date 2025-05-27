import Foundation

final class SearchSuggestionService {
    typealias SearchSuggestionResponse = (_ response: [String]?, _ error: NSError?) -> Void

    private let urlSession = URLSession(configuration: .ephemeral)
    private var task: URLSessionTask?
    private lazy var invalidResponseError: NSError = {
        NSError(
            domain: "SearchSuggestClient",
            code: 1,
            userInfo: nil
        )
    }()

    func query(_ url: URL, callback: @escaping SearchSuggestionResponse) {
        task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, error: error, callback)
        }
        task?.resume()
    }

    func handleResponse(data: Data?, response: URLResponse?, error: (any Error)?, _ callback: @escaping SearchSuggestionResponse) {
        guard let data = data,
              let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            callback(nil, invalidResponseError)
            return
        }

        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

        guard let array = json as? [Any], array.count >= 2 else {
            callback(nil, invalidResponseError)
            return
        }

        guard let suggestions = array[1] as? [String] else {
            callback(nil, invalidResponseError)
            return
        }

        callback(suggestions, nil)
    }
}
