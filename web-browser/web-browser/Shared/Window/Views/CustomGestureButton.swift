import SwiftUI

struct CustomGestureButton: View {
    let imageName: String
    let action: () -> Void
    let longPressAction: () -> Void
    let isDisabled: Bool

    init(imageName: String, action: @escaping () -> Void, longPressAction: @escaping () -> Void, isDisabled: Bool) {
        self.imageName = imageName
        self.action = action
        self.longPressAction = longPressAction
        self.isDisabled = isDisabled
    }

    var body: some View {
    #if canImport(AppKit)
        CustomMacOSButton(imageName: imageName,
                          isDisabled: isDisabled,
                          tapGestureAction: action,
                          longPressGestureAction: longPressAction)
    #else
        Button(action: {}) {
            Image(systemName: imageName)
        }
        .disabled(isDisabled)
        .simultaneousGesture(TapGesture().onEnded {
            action()
        })
        .simultaneousGesture(LongPressGesture().onEnded { _ in
            longPressAction()
        })
    #endif
    }
}


struct CustomMacOSButton: View {
    var imageName: String
    var isDisabled: Bool
    var tapGestureAction: () -> Void
    var longPressGestureAction: () -> Void

    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(isDisabled ? .gray : .white)
            .frame(width: 34, height: 22)
            .background(isDisabled ? Color.gray.opacity(0.3) : Color.gray)
            .cornerRadius(8)
            .onTapGesture {
                if !isDisabled {
                    tapGestureAction()
                }
            }
            .onLongPressGesture {
                if !isDisabled {
                    longPressGestureAction()
                }
            }
    }
}
