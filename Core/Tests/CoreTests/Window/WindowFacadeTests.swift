import XCTest
@testable import Core

class WindowFacadeTests: XCTestCase {

    func test_didRequestSearch_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    func test_didReload_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didReload()

        XCTAssertEqual(webView.receivedMessages, [.reload])
        XCTAssertEqual(presenter.receivedMessages, [])
    }

    func test_didStartEditing_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didStartEditing()

        XCTAssertEqual(presenter.receivedMessages, [.didStartEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didEndEditing_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didEndEditing()

        XCTAssertEqual(presenter.receivedMessages, [.didEndEditing])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didStopLoading_sendsCorrectMessage() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didStopLoading()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.stopLoading])
    }

    func test_didTapBackButton_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didTapBackButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapBackButton])
    }

    func test_didTapForwardButton_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didTapForwardButton()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(webView.receivedMessages, [.didTapForwardButton])
    }

    func test_didLongPressBackButton_sendsCorrectMessage() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didLongPressBackButton()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadBackList])
        XCTAssertEqual(webView.receivedMessages, [.retrieveBackList])
    }

    func test_didLongPressForwardButton_sendsCorrectMessage() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didLongPressForwardButton()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadForwardList])
        XCTAssertEqual(webView.receivedMessages, [.retrieveForwardList])
    }

    func test_didLoadPage_sendsCorrectMessages() {
        let (sut, webView, presenter, _, history) = makeSUT()
        let page = WebPage(title: "any", url: URL(string: "http://www.apple.com")!, date: Date())

        sut.didLoad(page: page)

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPage])
        XCTAssertEqual(history.receivedMessages, [.save])
        XCTAssertEqual(webView.receivedMessages, [])
    }

    func test_didUpdateNavigationButtons_sendsCorrectMessage() {
        let (sut, webView, presenter, safelist, history) = makeSUT()

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertEqual(presenter.receivedMessages, [.didUpdateNavigationButtons(canGoBack: true, canGoForward: true
                                                                               )])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [])
        XCTAssertEqual(safelist.receivedMessages, [])
    }

    func test_didUpdateLoadingProgress_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didUpdateLoadingProgress(0.5)

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didUpdateProgressBar(value: 0.5)])
    }

    func test_didSelectBackListPage_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didSelectBackListPage(at: 1)

        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
        XCTAssertEqual(webView.receivedMessages, [.navigateToBackListPage])
    }

    func test_didSelectForwardListPage_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didSelectForwardListPage(at: 1)

        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
        XCTAssertEqual(webView.receivedMessages, [.navigateToForwardListPage])
    }

    func test_didDismissBackForwardList_sendsCorrectMessages() {
        let (sut, webView, presenter, _, _) = makeSUT()

        sut.didDismissBackForwardList()

        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(presenter.receivedMessages, [.didDismissBackForwardList])
    }

    func test_updateSafelist_withURLEnabled_addURLToSafelist() {
        let (sut, _, _, safelist, _) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain(url)])
    }

    func test_updateSafelist_withURLDisabled_removesURLFromSafelist() {
        let (sut, _, _, safelist, _) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain(url)])
    }    

    // MARK: - Helpers

    private func makeSUT() -> (sut: WindowFacade, webView: WebViewSpy, presenter: WindowPresenterSpy, safelist: SafelistStoreSpy, history: HistoryStoreSpy) {
        let webView = WebViewSpy()
        let safelist = SafelistStoreSpy()
        let presenter = WindowPresenterSpy(safelist: safelist)
        let history = HistoryStoreSpy()
        let sut = WindowFacade(webView: webView, presenter: presenter, safelist: safelist, history: history)

        return (sut, webView, presenter, safelist, history)
    }
}

private class HistoryStoreSpy: HistoryAPI {
    enum Message {
        case save
        case getPages
        case deletePages
        case deleteAllPages
    }

    var receivedMessages = [Message]()

    func save(page: WebPage) {
        receivedMessages.append(.save)
    }

    func getPages() -> [WebPage] {
        receivedMessages.append(.getPages)
        return []
    }

    func getPages(by searchTerm: String) -> [WebPage] {
        return []
    }

    func deletePages(withIDs ids: [UUID]) {
        receivedMessages.append(.deletePages)
    }

    func deleteAllPages() {
        receivedMessages.append(.deleteAllPages)
    }
}
