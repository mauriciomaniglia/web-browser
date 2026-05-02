import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct TabManagerTests {

    @Test("Loads web view with normalized URL on search")
    func didRequestSearch_loadsWebViewCorrectly() {
        let (sut, safelist, webView, historyStore) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        #expect(webView.receivedMessages == [.load(url: URL(string: "http://www.apple.com")!)])
        #expect(safelist.receivedMessages == [])
        #expect(historyStore.receivedMessages == [])
    }

    @Test("Adds URL to safelist when enabled")
    func updateSafelist_withURLEnabled_addsURLToSafelist() {
        let (sut, safelist, webView, historyStore) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        #expect(safelist.receivedMessages == [.saveDomain("http://some-url.com")])
        #expect(webView.receivedMessages == [])
        #expect(historyStore.receivedMessages == [])
    }

    @Test("Removes URL from safelist when disabled")
    func updateSafelist_withURLDisabled_removesURLFromSafelist() {
        let (sut, safelist, webView, historyStore) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        #expect(safelist.receivedMessages == [.removeDomain("http://some-url.com")])
        #expect(webView.receivedMessages == [])
        #expect(historyStore.receivedMessages == [])
    }

    @Test("Starts new window with blank state")
    func didStartNewWindow_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartNewWindow()

        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Resets to start page when starting a new window from any state")
    func didStartNewWindow_fromAnyPreviousState_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didStartNewWindow()

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Shows editing controls when focus gained with no page loaded")
    func didChangeFocus_whenFocused_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didChangeFocus(isFocused: true)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(model.showCancelButton)
        #expect(model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Shows editing controls while preserving loaded page when focus gained")
    func didChangeFocus_whenFocusedWithPageLoaded_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didChangeFocus(isFocused: true)

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(model.showCancelButton)
        #expect(model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Shows suggestions and updates input when typing changes")
    func didStartTyping_whenInputChanged_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "lin", newText: "linux")!

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == "linux")
        #expect(model.showCancelButton)
        #expect(model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.showWebView)
        #expect(model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Does nothing when typing input hasn't changed")
    func didStartTyping_whenInputDidNotChange_doesNothing() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "linux", newText: "linux")

        #expect(model == nil)
    }

    @Test("Does nothing when typing input becomes empty")
    func didStartTyping_whenInputIsEmpty_doesNothing() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didStartTyping(oldText: "linux", newText: "")

        #expect(model == nil)
    }

    @Test("Avoids redundant updates when input matches current model URL")
    func didStartTyping_whenInputMatchesCurrentURL_doesNothing() {
        let (sut, _, _, _) = makeSUT()

        _ = sut.didStartTyping(oldText: "", newText: "www.linux.com")
        let model = sut.didStartTyping(oldText: "", newText: "www.linux.com")

        #expect(model == nil)
    }

    @Test("Hides editing controls when focus lost with no page loaded")
    func didChangeFocus_whenNotFocused_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didChangeFocus(isFocused: false)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(!model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Shows reload and site protection when focus lost with page loaded")
    func didChangeFocus_whenNotFocusedWithPageLoaded_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didChangeFocus(isFocused: false)

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Updates navigation buttons state")
    func didUpdateNavigationButtons_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateNavigationButton(canGoBack: true, canGoForward: true)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(model.canGoBack)
        #expect(model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Loads page and derives title, host, and protection state")
    func didLoadPage_deliversCorrectState() {
        let (sut, safelist, _, _) = makeSUT()
        safelist.isOnSafelist = true

        let model = sut.didLoadPage(title: nil, url: URL(string:"http://some-url.com/some-random-path/123")!)

        #expect(model.title == "some-url.com")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(!model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Builds back list entries from web view history")
    func didLoadBackList_deliversCorrectState() {
        let (sut, _, webView, _) = makeSUT()
        let page1 = WebPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockBackList = [page1, page2, page3]
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didLoadBackList()

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.backList?[0].title == page3.url.absoluteString)
        #expect(model.backList?[0].url == page3.url.absoluteString)
        #expect(model.backList?[1].title == page2.url.absoluteString)
        #expect(model.backList?[1].url == page2.url.absoluteString)
        #expect(model.backList?[2].title == page1.title)
        #expect(model.backList?[2].url == page1.url.absoluteString)
        #expect(model.forwardList == nil)
    }

    @Test("Builds forward list entries from web view history")
    func didLoadForwardList_deliversCorrectState() {
        let (sut, _, webView, _) = makeSUT()
        let page1 = WebPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockFowardList = [page1, page2, page3]
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        let model = sut.didLoadForwardList()

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.forwardList?[0].title == page1.title)
        #expect(model.forwardList?[0].url == page1.url.absoluteString)
        #expect(model.forwardList?[1].title == page2.url.absoluteString)
        #expect(model.forwardList?[1].url == page2.url.absoluteString)
        #expect(model.forwardList?[2].title == page3.url.absoluteString)
        #expect(model.forwardList?[2].url == page3.url.absoluteString)
        #expect(model.backList == nil)
    }

    @Test("Selects a page from back list and clears lists")
    func didSelectBackListPage_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        _ = sut.didLoadForwardList()

        let model = sut.didSelectBackListPage(at: 1)

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.forwardList == nil)
        #expect(model.backList == nil)
    }

    @Test("Selects a page from forward list and clears lists")
    func didSelectForwardListPage_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()
        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        _ = sut.didLoadBackList()

        let model = sut.didSelectForwardListPage(at: 1)

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(!model.showStopButton)
        #expect(model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == nil)
        #expect(model.forwardList == nil)
        #expect(model.backList == nil)
    }

    @Test("Shows stop button and progress while loading")
    func didUpdateProgressBar_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(0.45)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == 0.45)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Hides progress and stop when load completes")
    func didUpdateProgressBar_whenValueIsOne_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(1)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(!model.showStopButton)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Clamps progress and shows reload when value > 1")
    func didUpdateProgressBar_whenValueGreaterThanOne_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        let model = sut.didUpdateProgressBar(1.5)

        #expect(model.title == "Start Page")
        #expect(model.urlHost == nil)
        #expect(model.fullURL == nil)
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(model.showReloadButton)
        #expect(!model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(!model.showStopButton)
        #expect(model.progressBarValue == nil)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
    }

    @Test("Shows progress while loading an already loaded page")
    func didUpdateProgressBar_whenNavigationUpdates_deliversCorrectState() {
        let (sut, _, _, _) = makeSUT()

        _ = sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        let model = sut.didUpdateProgressBar(0.45)

        #expect(model.title == "Some title")
        #expect(model.urlHost == "some-url.com")
        #expect(model.fullURL == "http://some-url.com/some-random-path/123")
        #expect(!model.showCancelButton)
        #expect(!model.showClearButton)
        #expect(model.showStopButton)
        #expect(!model.showReloadButton)
        #expect(model.showSiteProtection)
        #expect(model.isWebsiteProtected)
        #expect(model.showWebView)
        #expect(!model.showSearchSuggestions)
        #expect(!model.canGoBack)
        #expect(!model.canGoForward)
        #expect(model.progressBarValue == 0.45)
        #expect(model.backList == nil)
        #expect(model.forwardList == nil)
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

