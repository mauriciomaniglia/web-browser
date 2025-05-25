import Foundation

final class SearchAutocompleteService {
    typealias SearchAutocompleteResponse = (_ response: [String]?, _ error: NSError?) -> Void

    private let urlSession = URLSession(configuration: .ephemeral)
    private var task: URLSessionTask?
    private lazy var invalidResponseError: NSError = {
        NSError(
            domain: "SearchSuggestClient",
            code: 1,
            userInfo: nil
        )
    }()

    func query(_ url: URL, callback: @escaping SearchAutocompleteResponse) {
        task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode)
            else {
                callback(nil, self.invalidResponseError)
                return
            }

            let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)

            guard let array = json as? [Any], array.count >= 2 else {
                callback(nil, self.invalidResponseError)
                return
            }

            guard let suggestions = array[1] as? [String] else {
                callback(nil, self.invalidResponseError)
                return
            }

            callback(suggestions, nil)
        }
        task?.resume()
    }
}
