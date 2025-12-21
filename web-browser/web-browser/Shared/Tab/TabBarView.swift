import SwiftUI

struct TabBarView: View {
    let tabManager: TabManager

    @Binding var currentIndex: Int

    var onAdd: () -> Void
    var onClose: (Int) -> Void
    var onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tabManager.tabs.indices, id: \.self) { index in
                        TabView(
                            viewModel: tabManager.tabs[index].tabViewModel,
                            currentIndex: $currentIndex,
                            tabManager: tabManager,
                            index: index,
                            onClose: onClose,
                            onSelect: onSelect)
                    }
                }
                .padding(.horizontal, 8)
            }

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 32, height: 32)
                    .background(Color.clear)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 4)
        .background(Color.purple)
    }
}

struct TabView: View {
    @ObservedObject var viewModel: TabViewModel
    @Binding var currentIndex: Int

    let tabManager: TabManager
    let index: Int
    var onClose: (Int) -> Void
    var onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(viewModel.title)
                .font(.system(size: 14))
                .lineLimit(1)
            Button(action: { onClose(index) }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
            }
            .buttonStyle(.plain)
        }
        .frame(width: 150)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(index == currentIndex ? Color.gray.opacity(0.8) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4))
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            currentIndex = index
            onSelect(index)
            tabManager.didSelectTab(at: index)
        }
    }
}
