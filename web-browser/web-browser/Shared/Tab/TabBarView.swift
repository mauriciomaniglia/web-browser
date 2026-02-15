import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(tabBarManager.tabs.indices, id: \.self) { index in
                            TabButton(
                                viewModel: tabBarManager.tabs[index].tabViewModel,
                                isSelected: tabBarManager.tabs[index].id == tabBarManager.selectedTab!.id,
                                onSelect: { tabBarManager.didSelectTab(at: index) },
                                onClose: { tabBarManager.closeTab(at: index) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                Button(action: tabBarManager.createNewTab) {
                    Image(systemName: "plus")
                        .padding(8)
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            .background(Color.mint)
            .shadow(radius: 1)

            if let selectedTab = tabBarManager.selectedTab {
                VStack {
                    Spacer()
                    selectedTab.view
                        .id(selectedTab.id)
                }
            } else {
                Spacer()
                ContentUnavailableView("No Tabs Open", systemImage: "plus.square.on.square")
                Spacer()
            }
        }
    }
}

struct TabButton: View {
    @ObservedObject var viewModel: TabViewModel

    let isSelected: Bool
    let onSelect: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(viewModel.title)
                .font(.subheadline)
                .lineLimit(1)
            Spacer()
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
            }
            .buttonStyle(.plain)
            .padding(4)
            .background(Color.black.opacity(0.1))
            .clipShape(Circle())
        }
        .frame(width: 150)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
        .onTapGesture {
            onSelect()
        }
    }
}
