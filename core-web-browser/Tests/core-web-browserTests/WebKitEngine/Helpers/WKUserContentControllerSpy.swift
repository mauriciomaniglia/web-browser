import WebKit

class WKUserContentControllerSpy: WKUserContentController {
    enum Message {
        case add
        case removeAllContentRuleLists
    }

    var receivedMessages: [Message] = []

    override func add(_ contentRuleList: WKContentRuleList) {
        receivedMessages.append(.add)
    }

    override func removeAllContentRuleLists() {
        receivedMessages.append(.removeAllContentRuleLists)
    }
}
