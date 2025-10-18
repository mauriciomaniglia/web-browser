import XCTest
@testable import Services

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectWindowState() {
        let (sut, _, delegate) = makeSUT()

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
        let (sut, _, delegate) = makeSUT()
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didStartNewWindow()

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel, .didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()

        sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()
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
        let (sut, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "lin", newText: "linux")

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "linux", newText: "linux")

        XCTAssertEqual(delegate.receivedMessages, [])
        XCTAssertNil(delegate.presentableModel)
    }

    func test_didStartTyping_whenInputIsEmpty_shouldNotShowSearchSuggestions() {
        let (sut, _, delegate) = makeSUT()

        sut.didStartTyping(oldText: "linux", newText: "")

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertFalse(delegate.presentableModel!.showSearchSuggestions)
    }

    func test_didChangeFocus_whenIsNotFocused_deliversCorrectWindowState() {
        let (sut, _, delegate) = makeSUT()

        sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()
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
        let (sut, _, delegate) = makeSUT()

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, safelist, delegate) = makeSUT()
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
        let (sut, _, delegate) = makeSUT()
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WindowPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadBackList([page1, page2, page3])

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
        let (sut, _, delegate) = makeSUT()
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WindowPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadForwardList([page1, page2, page3])

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

    func test_didDismissBackForwardList_deliversCorrectWindowState() {
        let (sut, _, delegate) = makeSUT()
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadForwardList([page1, page2])

        sut.didDismissBackForwardList()

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
        let (sut, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(1)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()

        sut.didUpdateProgressBar(1.5)

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertNil(delegate.presentableModel!.title)
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
        let (sut, _, delegate) = makeSUT()

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

    private func makeSUT() -> (sut: WindowPresenter, safelist: SafelistStoreSpy, delegate: WindowPresenterDelegateMock) {
        let safelistSpy = SafelistStoreSpy()
        let sut = WindowPresenter(isOnSafelist: safelistSpy.isRegisteredDomain(_:))
        let delegate = WindowPresenterDelegateMock()
        sut.delegate = delegate

        return (sut, safelistSpy, delegate)
    }
}

private class WindowPresenterDelegateMock: WindowPresenterDelegate {
    enum Message {
        case didUpdatePresentableModel
    }

    var receivedMessages = [Message]()
    var presentableModel: WindowPresenter.Model?

    func didUpdatePresentableModel(_ model: WindowPresenter.Model) {
        receivedMessages.append(.didUpdatePresentableModel)
        presentableModel = model
    }
}

