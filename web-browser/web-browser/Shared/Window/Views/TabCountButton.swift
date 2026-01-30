import SwiftUI

struct TabCountButton: View {
    var count: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(count)")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(Color(.darkGray))
                .frame(width: 22, height: 22)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.darkGray), lineWidth: 2)
                )
        }
        .accessibilityLabel("\(count) open tabs")
    }
}
