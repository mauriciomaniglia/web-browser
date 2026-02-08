import XCTest
@testable import Services

class TabManagerTests: XCTestCase {

    func test_didRequestSearch_shouldLoadWebViewCorrectly() {
        let (sut, safelist, webView, historyStore) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
    }

    func test_updateSafelist_withURLEnabled_shouldAddURLToSafelist() {
        let (sut, safelist, webView, historyStore) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
    }

    func test_updateSafelist_withURLDisabled_shouldRemovesURLFromSafelist() {
        let (sut, safelist, webView, historyStore) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
    }

    func test_didStartNewWindow_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartNewWindow()

        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didStartNewWindow_whenCallFromAnyPreviousState_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didStartNewWindow()

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didChangeFocus_whenIsFocused_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertTrue(model.showCancelButton)
        XCTAssertTrue(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didChangeFocus_whenIsFocusedWithPageLoaded_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(model.showCancelButton)
        XCTAssertTrue(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didStartTyping_whenInputChanged_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "lin", newText: "linux")!

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertEqual(model.fullURL, "linux")
        XCTAssertTrue(model.showCancelButton)
        XCTAssertTrue(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.showWebView)
        XCTAssertTrue(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didStartTyping_whenInputDidNotChanged_doesNothing() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "linux", newText: "linux")

        XCTAssertNil(model)
    }

    func test_didStartTyping_whenInputIsEmpty_doesNothing() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "linux", newText: "")

        XCTAssertNil(model)
    }

    func test_didStartTyping_whenInputAndModelHasSameURL_shouldUpdateStateAgain() {
        let (sut, _, _, _) = makeSUT()

        _ = sut.didStartTyping(oldText: "", newText: "www.linux.com")
        let model = sut.didStartTyping(oldText: "", newText: "www.linux.com")

        XCTAssertNil(model)
    }

    func test_didChangeFocus_whenIsNotFocused_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertFalse(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didChangeFocus_whenIsNotFocusedWithPageALoaded_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didUpdateNavigationButtons_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateNavigationButton(canGoBack: true, canGoForward: true)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertTrue(model.canGoBack)
        XCTAssertTrue(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didLoadPage_deliversCorrectState() {
        let (sut, safelist, _, _) = makeSUT()
        safelist.isOnSafelist = true

        let model = sut.didLoadPage(title: nil, url: URL(string:"http://some-url.com/some-random-path/123")!)

        XCTAssertEqual(model.title, "some-url.com")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertFalse(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didLoadBackList_deliversCorrectState() {
        let (sut, _, webView, _) = makeSUT()
        let page1 = WebPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockBackList = [page1, page2, page3]
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didLoadBackList()

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertTrue(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertEqual(model.backList?[0].title, page3.url.absoluteString)
        XCTAssertEqual(model.backList?[0].url, page3.url.absoluteString)
        XCTAssertEqual(model.backList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(model.backList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(model.backList?[2].title, page1.title)
        XCTAssertEqual(model.backList?[2].url, page1.url.absoluteString)
        XCTAssertNil(model.forwardList)
    }

    func test_didLoadForwardList_deliversCorrectState() {
        let (sut, _, webView, _) = makeSUT()
        let page1 = WebPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockFowardList = [page1, page2, page3]
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didLoadForwardList()

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertTrue(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertEqual(model.forwardList?[0].title, page1.title)
        XCTAssertEqual(model.forwardList?[0].url, page1.url.absoluteString)
        XCTAssertEqual(model.forwardList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(model.forwardList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(model.forwardList?[2].title, page3.url.absoluteString)
        XCTAssertEqual(model.forwardList?[2].url, page3.url.absoluteString)
        XCTAssertNil(model.backList)
    }

    func test_didSelectBackListPage_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        _ = sut.didLoadForwardList()

        let model = sut.didSelectBackListPage(at: 1)

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.forwardList)
        XCTAssertNil(model.backList)
    }

    func test_didSelectForwardListPage_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        _ = sut.didLoadBackList()

        let model = sut.didSelectForwardListPage(at: 1)

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertFalse(model.showStopButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertNil(model.progressBarValue)
        XCTAssertNil(model.forwardList)
        XCTAssertNil(model.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertTrue(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertEqual(model.progressBarValue, 0.45)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didUpdateProgressBar_whenValueIsOne_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(1)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertFalse(model.showStopButton)
        XCTAssertEqual(model.progressBarValue, nil)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(1.5)

        XCTAssertEqual(model.title, "Start Page")
        XCTAssertNil(model.urlHost)
        XCTAssertNil(model.fullURL)
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertTrue(model.showReloadButton)
        XCTAssertFalse(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertFalse(model.showStopButton)
        XCTAssertEqual(model.progressBarValue, nil)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        let model = sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(model.title, "Some title")
        XCTAssertEqual(model.urlHost, "some-url.com")
        XCTAssertEqual(model.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(model.showCancelButton)
        XCTAssertFalse(model.showClearButton)
        XCTAssertTrue(model.showStopButton)
        XCTAssertFalse(model.showReloadButton)
        XCTAssertTrue(model.showSiteProtection)
        XCTAssertTrue(model.isWebsiteProtected)
        XCTAssertTrue(model.showWebView)
        XCTAssertFalse(model.showSearchSuggestions)
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertEqual(model.progressBarValue, 0.45)
        XCTAssertNil(model.backList)
        XCTAssertNil(model.forwardList)
    }

    // MARK: -- Helpers

    private func makeSUT() -> (sut: TabManager<WebViewSpy, SafelistStoreSpy, HistoryStoreMock>,
                               safelist: SafelistStoreSpy,
                               webView: WebViewSpy,
                               historyStore: HistoryStoreMock)
    {
        let webView = WebViewSpy()
        let safelist = SafelistStoreSpy()
        let historyStore = HistoryStoreMock()
        let sut = TabManager(
            webView: webView,
            safelistStore: safelist,
            historyStore: historyStore)

        return (sut, safelist, webView, historyStore)
    }
}

