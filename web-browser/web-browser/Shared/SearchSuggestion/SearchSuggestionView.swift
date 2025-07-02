import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.searchSuggestions.isEmpty {
                SuggestionSectionView(
                    title: "Google Suggestions",
                    suggestions: viewModel.searchSuggestions,
                    iconName: "magnifyingglass",
                    onTap: viewModel.didSelectPage
                )
            }

            if !viewModel.bookmarkSuggestions.isEmpty {
                SuggestionSectionView(
                    title: "Bookmarks",
                    suggestions: viewModel.bookmarkSuggestions,
                    iconName: "bookmark.fill",
                    onTap: viewModel.didSelectPage
                )
            }

            if !viewModel.historyPageSuggestions.isEmpty {
                SuggestionSectionView(
                    title: "History",
                    suggestions: viewModel.historyPageSuggestions,
                    iconName: "clock.arrow.circlepath",
                    onTap: viewModel.didSelectPage
                )
            }
        }
        .padding()

        Spacer()
    }
}

struct SuggestionSectionView: View {
    let title: String
    let suggestions: [SearchSuggestionViewModel.Item]
    let iconName: String
    let onTap: ((URL) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ForEach(suggestions) { model in
                Button(action: {
                    onTap?(model.url)
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: iconName)
                            .foregroundColor(.gray)
                        Text(model.title)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .contentShape(Rectangle())
                }
                .buttonStyle(PlainButtonStyle())

                Divider()
                    .padding(.leading, 44)
            }
        }
    }
}
