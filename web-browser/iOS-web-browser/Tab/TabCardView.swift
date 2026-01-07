import SwiftUI

struct TabCardView: View {
    @EnvironmentObject var tabManager: TabManager
    @Binding var isPresented: Bool
    @ObservedObject var tab: TabComposer

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
                closeButton
                screenshotPlaceholder
                Spacer()
                cardTitle

            }
            .frame(width: cardWidth)
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5)
        }

    }

    var closeButton: some View {
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

    var screenshotPlaceholder: some View {
        Group {
            if let image = tab.snapshot {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardWidth - 20, height: cardWidth - 20)
                    .clipped()
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .overlay(Text("Loading...").foregroundColor(.white))
            }
        }
        .frame(height: cardWidth - 20)
        .cornerRadius(15)
        .padding(.horizontal, 10)
    }
    
    var cardTitle: some View {
        Text(tab.tabViewModel.title)
            .font(.subheadline)
            .lineLimit(1)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
    }
}
