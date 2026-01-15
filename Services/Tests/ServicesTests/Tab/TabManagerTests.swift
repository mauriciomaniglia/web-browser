import XCTest
@testable import Services

class TabManagerTests: XCTestCase {

    func test_didRequestSearch_shouldLoadWebViewCorrectly() {
        let (sut, safelist, webView, historyStore, delegate) = makeSUT()

        sut.didRequestSearch("www.apple.com")

        XCTAssertEqual(webView.receivedMessages, [.load(url: URL(string: "http://www.apple.com")!)])
        XCTAssertEqual(safelist.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_updateSafelist_withURLEnabled_addURLToSafelist() {
        let (sut, safelist, webView, historyStore, delegate) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: true)

        XCTAssertEqual(safelist.receivedMessages, [.saveDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_updateSafelist_withURLDisabled_removesURLFromSafelist() {
        let (sut, safelist, webView, historyStore, delegate) = makeSUT()
        let url = "http://some-url.com"

        sut.updateSafelist(url: url, isEnabled: false)

        XCTAssertEqual(safelist.receivedMessages, [.removeDomain("http://some-url.com")])
        XCTAssertEqual(webView.receivedMessages, [])
        XCTAssertEqual(historyStore.receivedMessages, [])
        XCTAssertEqual(delegate.receivedMessages, [])
    }

    func test_didStartNewWindow_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didStartNewWindow()

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didStartNewWindow_whenCallFromAnyPreviousState_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didStartNewWindow()

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didChangeFocus_whenIsFocused_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertTrue(delegate.presentableModel!.showCancelButton)
        XCTAssertTrue(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didChangeFocus_whenIsFocusedWithPageLoaded_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(delegate.presentableModel!.showCancelButton)
        XCTAssertTrue(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didStartTyping_whenInputChanged_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "lin", newText: "linux")

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertEqual(delegate.presentableModel!.fullURL, "linux")
        XCTAssertTrue(delegate.presentableModel!.showCancelButton)
        XCTAssertTrue(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.showWebView)
        XCTAssertTrue(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didStartTyping_whenInputDidNotChanged_doesNothing() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "linux", newText: "linux")

        XCTAssertEqual(delegate.receivedMessages, [])
        XCTAssertNil(delegate.presentableModel)
    }

    func test_didStartTyping_whenInputIsEmpty_shouldNotShowSearchSuggestions() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "linux", newText: "")

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
    }

    func test_didStartTyping_whenInputAndModelHasSameURL_shouldNotCallSearchSuggestionsAgain() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "", newText: "www.linux.com")
        sut.didStartTyping(oldText: "", newText: "www.linux.com")

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertTrue(delegate.presentableModel!.showSearchSuggestions)
    }

    func test_didChangeFocus_whenIsNotFocused_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertFalse(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didChangeFocus_whenIsNotFocusedWithPageALoaded_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didUpdateNavigationButtons_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertTrue(delegate.presentableModel!.canGoBack)
        XCTAssertTrue(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didLoadPage_deliversCorrectWindowState() {
        let (sut, safelist, _, _, delegate) = makeSUT()
        safelist.isOnSafelist = true

        sut.didLoadPage(title: nil, url: URL(string:"http://some-url.com/some-random-path/123")!)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertFalse(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didLoadBackList_deliversCorrectWindowState() {
        let (sut, _, webView, _, delegate) = makeSUT()
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockBackList = [page1, page2, page3]
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadBackList()

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertEqual(delegate.presentableModel!.backList?[0].title, page3.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.backList?[0].url, page3.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.backList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.backList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.backList?[2].title, page1.title)
        XCTAssertEqual(delegate.presentableModel!.backList?[2].url, page1.url.absoluteString)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didLoadForwardList_deliversCorrectWindowState() {
        let (sut, _, webView, _, delegate) = makeSUT()
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        webView.mockFowardList = [page1, page2, page3]
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadForwardList()

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[0].title, page1.title)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[0].url, page1.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[2].title, page3.url.absoluteString)
        XCTAssertEqual(delegate.presentableModel!.forwardList?[2].url, page3.url.absoluteString)
        XCTAssertNil(delegate.presentableModel!.backList)
    }

    func test_didSelectBackListPage_deliversCorrectWindowState() {
        let (sut, _, webView, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadForwardList()

        sut.didSelectBackListPage(at: 1)

        XCTAssertEqual(webView.receivedMessages, [
            .retrieveForwardList,
            .navigateToBackListPage
        ])
        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.forwardList)
        XCTAssertNil(delegate.presentableModel!.backList)
    }

    func test_didSelectForwardListPage_deliversCorrectWindowState() {
        let (sut, _, webView, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadBackList()

        sut.didSelectForwardListPage(at: 1)

        XCTAssertEqual(webView.receivedMessages, [.retrieveBackList, .navigateToForwardListPage])
        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertNil(delegate.presentableModel!.progressBarValue)
        XCTAssertNil(delegate.presentableModel!.forwardList)
        XCTAssertNil(delegate.presentableModel!.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertTrue(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertEqual(delegate.presentableModel!.progressBarValue, 0.45)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueIsOne_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(1)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertEqual(delegate.presentableModel!.progressBarValue, nil)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(1.5)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Start Page")
        XCTAssertNil(delegate.presentableModel!.urlHost)
        XCTAssertNil(delegate.presentableModel!.fullURL)
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertTrue(delegate.presentableModel!.showReloadButton)
        XCTAssertFalse(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertFalse(delegate.presentableModel!.showStopButton)
        XCTAssertEqual(delegate.presentableModel!.progressBarValue, nil)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectWindowState() {
        let (sut, _, _, _, delegate) = makeSUT()

        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.title, "Some title")
        XCTAssertEqual(delegate.presentableModel!.urlHost, "some-url.com")
        XCTAssertEqual(delegate.presentableModel!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(delegate.presentableModel!.showCancelButton)
        XCTAssertFalse(delegate.presentableModel!.showClearButton)
        XCTAssertTrue(delegate.presentableModel!.showStopButton)
        XCTAssertFalse(delegate.presentableModel!.showReloadButton)
        XCTAssertTrue(delegate.presentableModel!.showSiteProtection)
        XCTAssertTrue(delegate.presentableModel!.isWebsiteProtected)
        XCTAssertTrue(delegate.presentableModel!.showWebView)
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
        XCTAssertFalse(delegate.presentableModel!.canGoBack)
        XCTAssertFalse(delegate.presentableModel!.canGoForward)
        XCTAssertEqual(delegate.presentableModel!.progressBarValue, 0.45)
        XCTAssertNil(delegate.presentableModel!.backList)
        XCTAssertNil(delegate.presentableModel!.forwardList)
    }

    // MARK: -- Helpers

    private func makeSUT() -> (sut: TabManager,
                               safelist: SafelistStoreSpy,
                               webView: WebViewSpy,
                               historyStore: HistoryStoreMock,
                               delegate: TabManagerDelegateMock)
    {
        let webView = WebViewSpy()
        let safelist = SafelistStoreSpy()
        let historyStore = HistoryStoreMock()
        let sut = TabManager(
            webView: webView,
            safelistStore: safelist,
            historyStore: historyStore)
        let delegate = TabManagerDelegateMock()
        sut.delegate = delegate

        return (sut, safelist, webView, historyStore, delegate)
    }
}

private class TabManagerDelegateMock: TabManagerDelegate {
    enum Message {
        case didUpdatePresentableModel
    }

    var receivedMessages = [Message]()
    var presentableModel: TabManager.Model?

    func didUpdatePresentableModel(_ model: TabManager.Model) {
        receivedMessages.append(.didUpdatePresentableModel)
        presentableModel = model
    }
}

