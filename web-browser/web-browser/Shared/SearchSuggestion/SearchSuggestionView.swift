import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("GOOGLE SUGGESTIONS")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ForEach(viewModel.searchSuggestions) { suggestion in
                SearchSuggestionRow(image: "magnifyingglass", suggestion: suggestion.title) {
                    viewModel.delegate?.didSelectPage(suggestion.url)
                }
            }

            Text("BOOKMARK")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ForEach(viewModel.bookmarkSuggestions) { bookmark in
                SearchSuggestionRow(image: "bookmark.fill", suggestion: bookmark.title) {
                    viewModel.delegate?.didSelectPage(bookmark.url)
                }
            }

            Text("HISTORY")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ForEach(viewModel.historyPageSuggestions) { history in
                SearchSuggestionRow(image: "clock.arrow.circlepath", suggestion: history.title) {
                    viewModel.delegate?.didSelectPage(history.url)
                }
            }
        }
        .frame(minWidth: 200, maxWidth: 500)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.accentColor)
                .shadow(radius: 5)
        )
        .cornerRadius(10)
    }
}

struct SearchSuggestionRow: View {
    let image: String
    let suggestion: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                Text(suggestion)
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.primary)
    }
}
