import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !viewModel.searchSuggestions.isEmpty {
                SuggestionSectionView(
                    viewModel: viewModel,
                    title: "Google Suggestions",
                    suggestions: viewModel.searchSuggestions,
                    iconName: "magnifyingglass"
                )
            }

            if !viewModel.bookmarkSuggestions.isEmpty {
                SuggestionSectionView(
                    viewModel: viewModel,
                    title: "Bookmarks",
                    suggestions: viewModel.bookmarkSuggestions,
                    iconName: "bookmark.fill"
                )
            }

            if !viewModel.historyPageSuggestions.isEmpty {
                SuggestionSectionView(
                    viewModel: viewModel,
                    title: "History",
                    suggestions: viewModel.historyPageSuggestions,
                    iconName: "clock.arrow.circlepath"
                )
            }
        }
        .padding()

        Spacer()
    }
}

struct SuggestionSectionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    let title: String
    let suggestions: [SearchSuggestionViewModel.Item]
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)

            ForEach(suggestions) { model in
                Button(action: {
                    viewModel.delegate?.didSelectPage(model.url)
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
