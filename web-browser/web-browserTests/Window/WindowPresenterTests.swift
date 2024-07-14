import XCTest
@testable import web_browser
@testable import core_web_browser

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didStartNewWindow_deliversCorrectValuesWhenCallFromAnyPreviousState() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didStartEditing_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartEditing()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertEqual(receivedResult!.showCancelButton, showCancelButton())
        XCTAssertTrue(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didStartEditing_deliversCorrectValuesWithPageAlreadyLoaded() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didStartEditing()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertEqual(receivedResult!.showCancelButton, showCancelButton())
        XCTAssertTrue(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didEndEditing_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didEndEditing()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didEndEditing_deliversCorrectValuesWithPageAlreadyLoaded() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didEndEditing()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didUpdateNavigationButtons_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didLoadPage_deliversCorrectValues() {
        let (sut, safelist) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        safelist.isOnSafelist = true

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertFalse(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didLoadBackList_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadBackList([page1, page2, page3])

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertEqual(receivedResult!.backList?[0].title, page3.url.absoluteString)
        XCTAssertEqual(receivedResult!.backList?[0].url, page3.url.absoluteString)
        XCTAssertEqual(receivedResult!.backList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(receivedResult!.backList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(receivedResult!.backList?[2].title, page1.title)
        XCTAssertEqual(receivedResult!.backList?[2].url, page1.url.absoluteString)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didLoadForwardList_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadForwardList([page1, page2, page3])

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertEqual(receivedResult!.forwardList?[0].title, page1.title)
        XCTAssertEqual(receivedResult!.forwardList?[0].url, page1.url.absoluteString)
        XCTAssertEqual(receivedResult!.forwardList?[1].title, page2.url.absoluteString)
        XCTAssertEqual(receivedResult!.forwardList?[1].url, page2.url.absoluteString)
        XCTAssertEqual(receivedResult!.forwardList?[2].title, page3.url.absoluteString)
        XCTAssertEqual(receivedResult!.forwardList?[2].url, page3.url.absoluteString)
        XCTAssertNil(receivedResult!.backList)
    }

    func test_didDismissBackForwardList_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadForwardList([page1, page2])

        sut.didDismissBackForwardList()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.forwardList)
        XCTAssertNil(receivedResult!.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(0.45)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertTrue(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertEqual(receivedResult!.progressBarValue, 0.45)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueIsOne_stopButtonAndProgressBarShouldNotBeVisible() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertEqual(receivedResult!.progressBarValue, nil)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_stopButtonAndProgressBarShouldNotBeVisible() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1.5)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertEqual(receivedResult!.progressBarValue, nil)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectValues() {
        let (sut, _) = makeSUT()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showMenuButton)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertTrue(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertEqual(receivedResult!.progressBarValue, 0.45)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    // MARK: -- Helpers

    private func makeSUT() -> (sut: WindowPresenter, safelist: SafelistStoreSpy) {
        let safelistSpy = SafelistStoreSpy()
        let sut = WindowPresenter(safelist: safelistSpy)

        return (sut, safelistSpy)
    }

    private func showCancelButton() -> Bool {
        #if os(iOS)
        true
        #elseif os(macOS)
        false
        #elseif os(visionOS)
        false
        #endif
    }
}
