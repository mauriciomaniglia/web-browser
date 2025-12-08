import SwiftUI

struct SearchSuggestionView: View {
    @ObservedObject var viewModel: SearchSuggestionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SearchSuggestionSection(
                title: "GOOGLE SUGGESTIONS",
                icon: "magnifyingglass",
                items: viewModel.searchSuggestions,
                action: viewModel.delegate!.didSelectPage)

            SearchSuggestionSection(
                title: "BOOKMARK",
                icon: "bookmark.fill",
                items: viewModel.bookmarkSuggestions,
                action: viewModel.delegate!.didSelectPage)

            SearchSuggestionSection(
                title: "HISTORY",
                icon: "clock.arrow.circlepath",
                items: viewModel.historyPageSuggestions,
                action: viewModel.delegate!.didSelectPage)
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

struct SearchSuggestionSection: View {
    let title: String
    let icon: String
    let items: [SearchSuggestionViewModel.Item]
    let action: (URL) -> Void

    var body: some View {
        if !items.isEmpty {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.top, 8)
        }

        ForEach(items) { item in
            SearchSuggestionRow(title: item.title, image: icon) {
                action(item.url)
            }
        }
    }
}

struct SearchSuggestionRow: View {
    let title: String
    let image: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: image)
                Text(title)
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
