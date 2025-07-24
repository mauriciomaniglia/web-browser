import XCTest
@testable import Services

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didStartNewWindow()

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartNewWindow_whenCallFromAnyPreviousState_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didStartNewWindow()

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didChangeFocus_whenIsFocused_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didChangeFocus(isFocused: true)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertTrue(windowState!.showCancelButton)
        XCTAssertTrue(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didChangeFocus_whenIsFocusedWithPageLoaded_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didChangeFocus(isFocused: true)

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(windowState!.showCancelButton)
        XCTAssertTrue(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartTyping_whenInputChanged_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didStartTyping(oldText: "lin", newText: "linux")

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertEqual(windowState!.fullURL, "linux")
        XCTAssertTrue(windowState!.showCancelButton)
        XCTAssertTrue(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertTrue(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartTyping_whenInputDidNotChanged_doesNothing() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didStartTyping(oldText: "linux", newText: "linux")

        XCTAssertNil(windowState)
    }

    func test_didStartTyping_whenInputIsEmpty_shouldNotShowSearchSuggestions() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didStartTyping(oldText: "linux", newText: "")

        XCTAssertFalse(windowState!.showSearchSuggestions)
    }

    func test_didChangeFocus_whenIsNotFocused_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didChangeFocus(isFocused: false)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didChangeFocus_whenIsNotFocusedWithPageALoaded_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didChangeFocus(isFocused: false)

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateNavigationButtons_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertTrue(windowState!.canGoBack)
        XCTAssertTrue(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didLoadPage_deliversCorrectWindowState() {
        let (sut, safelist) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }
        safelist.isOnSafelist = true

        sut.didLoadPage(title: nil, url: URL(string:"http://some-url.com/some-random-path/123")!)

        XCTAssertEqual(windowState!.title, "some-url.com")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertFalse(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didLoadBackList_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WindowPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadBackList([page1, page2, page3])

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertEqual(windowState!.backList?[0].title, page3.url.absoluteString)
        XCTAssertEqual(windowState!.backList?[0].url, page3.url.absoluteString)
        XCTAssertEqual(windowState!.backList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(windowState!.backList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(windowState!.backList?[2].title, page1.title)
        XCTAssertEqual(windowState!.backList?[2].url, page1.url.absoluteString)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didLoadForwardList_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WindowPageModel(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadForwardList([page1, page2, page3])

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertEqual(windowState!.forwardList?[0].title, page1.title)
        XCTAssertEqual(windowState!.forwardList?[0].url, page1.url.absoluteString)
        XCTAssertEqual(windowState!.forwardList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(windowState!.forwardList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(windowState!.forwardList?[2].title, page3.url.absoluteString)
        XCTAssertEqual(windowState!.forwardList?[2].url, page3.url.absoluteString)
        XCTAssertNil(windowState!.backList)
    }

    func test_didDismissBackForwardList_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        let page1 = WindowPageModel(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WindowPageModel(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadForwardList([page1, page2])

        sut.didDismissBackForwardList()

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.forwardList)
        XCTAssertNil(windowState!.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(0.45)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertEqual(windowState!.progressBarValue, 0.45)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueIsOne_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(1)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertEqual(windowState!.progressBarValue, nil)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(1.5)

        XCTAssertNil(windowState!.title)
        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertEqual(windowState!.progressBarValue, nil)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresenter.Model?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(title: "Some title", url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(windowState!.title, "Some title")
        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.showSearchSuggestions)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertEqual(windowState!.progressBarValue, 0.45)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    // MARK: -- Helpers

    private func makeSUT() -> (sut: WindowPresenter, safelist: SafelistStoreSpy) {
        let safelistSpy = SafelistStoreSpy()
        let sut = WindowPresenter(isOnSafelist: safelistSpy.isRegisteredDomain(_:))

        return (sut, safelistSpy)
    }
}

