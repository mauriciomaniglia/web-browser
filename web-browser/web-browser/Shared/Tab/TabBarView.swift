import SwiftUI

struct TabBarView: View {
    @ObservedObject var tabBarManager: TabBarManager<TabSessionStore>

    let layout: TabBarLayout

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(tabBarManager.tabs.indices, id: \.self) { index in
                            TabButton(
                                viewModel: tabBarManager.tabs[index].tabViewModel,
                                layout: layout,
                                isSelected: tabBarManager.tabs[index].id == tabBarManager.selectedTab.id,
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
            .background(layout.color)
            .shadow(radius: 1)

            VStack {
                Spacer()
                tabBarManager.selectedTab.view
                    .id(tabBarManager.selectedTab.id)
            }
        }
    }
}

struct TabButton: View {
    @ObservedObject var viewModel: TabViewModel

    let layout: TabBarLayout
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
        .padding(layout.innerPadding)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(layout.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: layout.cornerRadius)
                .stroke(isSelected ? layout.selectedColor : layout.unselectedColor, lineWidth: 1)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

struct TabBarLayout {
    let padding: CGFloat
    let innerPadding: CGFloat
    let cornerRadius: CGFloat
    let color: Color
    let selectedColor: Color
    let unselectedColor: Color
}
