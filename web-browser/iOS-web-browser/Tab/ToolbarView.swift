import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var tabManager: TabManager
    @Binding var isPresented: Bool

    // MARK: - Body

    var body: some View {
        HStack {
            newTabButton
            Spacer()
            closeButton
        }
        .frame(height: 50)
        .padding(.bottom, 20)
        .background(
            blurBackground
        )
    }

    // MARK: - Buttons

    var newTabButton: some View {
        Button {
            tabManager.createNewTab()
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

    // MARK: - Visual Effects

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

