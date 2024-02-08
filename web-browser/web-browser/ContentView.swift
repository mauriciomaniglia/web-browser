import SwiftUI

struct ContentView: View {
    let composer = WindowComposer()

    var body: some View {
        AnyView(composer.composeView())        
    }
}

#Preview {
    ContentView()
}
