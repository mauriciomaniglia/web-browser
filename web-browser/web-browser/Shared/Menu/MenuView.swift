import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {

            }

        }
        .presentationCompactAdaptation((.popover))
    }
}

#Preview {
    MenuView()
}
