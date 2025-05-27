import Foundation

protocol SearchSuggestionServiceContract {
    func query(_ url: URL, callback: @escaping SearchSuggestionService.SearchSuggestionResponse)
}

final class SearchSuggestionService: SearchSuggestionServiceContract {
    typealias SearchSuggestionResponse = (_ suggestions: [String]?) -> Void

    private let urlSession = URLSession(configuration: .ephemeral)
    private var task: URLSessionTask?

    func query(_ url: URL, callback: @escaping SearchSuggestionResponse) {
        task = urlSession.dataTask(with: url) { [weak self] data, response, error in
            self?.handleResponse(data: data, response: response, callback)
        }
        task?.resume()
    }

    func handleResponse(data: Data?, response: URLResponse?, _ callback: @escaping SearchSuggestionResponse) {
        guard let data = data,
              let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode)
        else {
            callback(nil)
            return
        }

        let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

        guard let array = json as? [Any], array.count >= 2 else {
            callback(nil)
            return
        }

        guard let suggestions = array[1] as? [String] else {
            callback(nil)
            return
        }

        callback(suggestions)
    }
}
