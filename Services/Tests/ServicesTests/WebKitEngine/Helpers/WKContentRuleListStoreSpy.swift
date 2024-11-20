import WebKit

class WKContentRuleListStoreSpy: WKContentRuleListStore {
    enum Message: Equatable {
        case lookUpContentRuleList(identifier: String)
        case compileContentRuleList(identifier: String, encodedContentRuleList: String = "")
    }

    var receivedMessages = [Message]()
    var lookUpContentRuleListCompletion: ((WKContentRuleList?, Error?) -> Void)?

    override func lookUpContentRuleList(forIdentifier identifier: String!, completionHandler: ((WKContentRuleList?, Error?) -> Void)!) {
        lookUpContentRuleListCompletion = completionHandler
        receivedMessages.append(.lookUpContentRuleList(identifier: identifier))
    }

    override func compileContentRuleList(forIdentifier identifier: String!, encodedContentRuleList: String!, completionHandler: ((WKContentRuleList?, Error?) -> Void)!) {
        receivedMessages.append(.compileContentRuleList(identifier: identifier, encodedContentRuleList: encodedContentRuleList))
        super.compileContentRuleList(forIdentifier: identifier, encodedContentRuleList: encodedContentRuleList, completionHandler: completionHandler)
    }

    func simulateLookUpContentRuleListWithRegisteredItem() {
        lookUpContentRuleListCompletion?(WKContentRuleList(), nil)
    }

    func simulateLookUpContentRuleListWithUnregisteredItem() {
        lookUpContentRuleListCompletion?(nil, nil)
    }
}
