import SwiftUI

struct TabManagerView: View {
    var tabBarManager: TabBarManager
    @Binding var isPresented: Bool

    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(tabBarManager.tabs.indices, id: \.self) { index in
                        TabCardView(isPresented: $isPresented, tab: tabBarManager.tabs[index], index: index)
                            .environmentObject(tabBarManager)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
            .background(Color(.systemGroupedBackground))

            ToolbarView(isPresented: $isPresented)
                .environmentObject(tabBarManager)

        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabCardView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
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
            tabBarManager.didSelectTab(at: index)
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
                tabBarManager.closeTab(at: index)
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
            .foregroundStyle(Color(.darkGray))        
            .font(.subheadline)
            .lineLimit(1)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
    }
}

struct ToolbarView: View {
    @EnvironmentObject var tabBarManager: TabBarManager
    @Binding var isPresented: Bool

    var body: some View {
        HStack {
            newTabButton
            Spacer()
            closeButton
        }
        .frame(height: 50)
        .padding(.bottom, 20)
        .buttonStyle(PlainButtonStyle())
        .background(
            blurBackground
        )
    }

    var newTabButton: some View {
        Button {
            tabBarManager.createNewTab()
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("New Tab")
            }
        }
        .font(.headline)
        .padding(.leading, 15)
    }

    var closeButton: some View {
        Button("Done") {
            isPresented = false
        }
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.trailing, 15)
    }

    var blurBackground: some View {
        VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
            .ignoresSafeArea()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
