import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var tabManager: TabManager
    @Binding var isPresented: Bool

    var body: some View {
        HStack {
            NewTabButton
            Spacer()
            DoneButton
        }
        .frame(height: 50)
        .padding(.bottom, 20)
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                .ignoresSafeArea()
        )
    }

    private var NewTabButton: some View {
        Button {
            tabManager.addNewTab()
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("New Tab")
            }
        }
        .font(.headline)
        .padding(.leading, 15)
    }

    private var DoneButton: some View {
        Button("Done") {
            isPresented = false
        }
        .font(.headline)
        .fontWeight(.semibold)
        .padding(.trailing, 15)
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

