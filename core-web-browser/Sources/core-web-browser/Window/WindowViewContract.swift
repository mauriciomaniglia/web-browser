public protocol WindowViewContract {
    func didRequestSearch(_ text: String)
    func didStartTyping()
    func didEndTyping()
    func didTapBackButton()
    func didTapForwardButton()
}
