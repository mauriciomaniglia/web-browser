import SwiftUI

struct TabCardView: View {
    @EnvironmentObject var tabManager: TabManager
    @Binding var isPresented: Bool

    var tab: TabComposer
    var index: Int

    struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let spacing: CGFloat = 10
        static let columns: CGFloat = 2
    }

    let cardWidth = (Constants.screenWidth - 3 * Constants.spacing) / Constants.columns

    var body: some View {
        Button {
            tabManager.didSelectTab(at: index)
            isPresented = false
        } label: {
            VStack {
                CloseButton
                ScreenshotPlaceholder
                Spacer()
                CardTitle

            }
            .frame(width: cardWidth)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        }

    }

    private var CloseButton: some View {
        HStack {
            Spacer()
            Button {
                tabManager.closeTab(tab)
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .padding([.top, .trailing], 8)
            }
        }
        .background(Color(.systemBackground))
    }

    private var ScreenshotPlaceholder: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(Color.mint)
            .aspectRatio(1, contentMode: .fit)
            .padding(.horizontal, 10)
            .overlay(
                Text("Placeholder")
                    .foregroundColor(.white)
                    .font(.headline)
            )
    }

    private var CardTitle: some View {
        Text(tab.tabViewModel.title)
            .font(.subheadline)
            .lineLimit(1)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
    }
}
