import XCTest
@testable import web_browser
@testable import core_web_browser

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartEditing()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didStartEditing()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertEqual(receivedResult!.showCancelButton, showCancelButton())
        XCTAssertTrue(receivedResult!.showClearButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didEndEditing_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didEndEditing()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didEndEditing()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
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

    func test_didLoadBackList_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: "www.page1.com")
        let page2 = WebPage(title: nil, url: "www.page2.com")
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)

        sut.didLoadBackList([page1, page2])

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
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
        XCTAssertEqual(receivedResult!.backList?.first?.title, page2.url)
        XCTAssertEqual(receivedResult!.backList?.first?.url, page2.url)
        XCTAssertEqual(receivedResult!.backList?.last?.title, page1.title)
        XCTAssertEqual(receivedResult!.backList?.last?.url, page1.url)
        XCTAssertNil(receivedResult!.forwardList)
    }

    func test_didLoadForwardList_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: "www.page1.com")
        let page2 = WebPage(title: nil, url: "www.page2.com")
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)

        sut.didLoadForwardList([page1, page2])

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
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
        XCTAssertEqual(receivedResult!.forwardList?.first?.title, page1.title)
        XCTAssertEqual(receivedResult!.forwardList?.first?.url, page1.url)
        XCTAssertEqual(receivedResult!.forwardList?.last?.title, page2.url)
        XCTAssertEqual(receivedResult!.forwardList?.last?.url, page2.url)
        XCTAssertNil(receivedResult!.backList)
    }

    func test_didDismissBackForwardList_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: "www.page1.com")
        let page2 = WebPage(title: nil, url: "www.page2.com")
        sut.didUpdatePresentableModel = { receivedResult = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didLoadForwardList([page1, page2])

        sut.didDismissBackForwardList()

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
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
        XCTAssertNil(receivedResult!.forwardList)
        XCTAssertNil(receivedResult!.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(0.45)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1.5)

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
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
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showClearButton)
        XCTAssertTrue(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertEqual(receivedResult!.progressBarValue, 0.45)
        XCTAssertNil(receivedResult!.backList)
        XCTAssertNil(receivedResult!.forwardList)
    }

    // MARK: -- Helpers

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
