import SwiftUI

struct TabBarView: View {
    let tabFactory: TabViewFactory

    var tabs: [String]
    @Binding var currentIndex: Int
    var onAdd: () -> Void
    var onClose: (Int) -> Void
    var onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tabs.indices, id: \.self) { index in
                        HStack(spacing: 4) {
                            Text(tabs[index])
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Button(action: { onClose(index) }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(index == currentIndex ? Color.gray.opacity(0.2) : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.4))
                                )
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            currentIndex = index
                            onSelect(index)
                            tabFactory.didSelectTabAt(index: index)
                        }
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
