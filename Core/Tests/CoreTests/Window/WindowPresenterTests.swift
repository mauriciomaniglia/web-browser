import XCTest
@testable import Core

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
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
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartNewWindow_whenCallFromAnyPreviousState_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
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
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartEditing_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didStartEditing()

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertEqual(windowState!.showCancelButton, showCancelButton())
        XCTAssertTrue(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didStartEditing_withPageAlreadyLoaded_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didStartEditing()

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertEqual(windowState!.showCancelButton, showCancelButton())
        XCTAssertTrue(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didEndEditing_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didEndEditing()

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertFalse(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didEndEditing_withPageAlreadyLoaded_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didEndEditing()

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateNavigationButtons_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateNavigationButtons(canGoBack: true, canGoForward: true)

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertTrue(windowState!.canGoBack)
        XCTAssertTrue(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didLoadPage_deliversCorrectWindowState() {
        let (sut, safelist) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }
        safelist.isOnSafelist = true

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertFalse(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didLoadBackList_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadBackList([page1, page2, page3])

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
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
        var windowState: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        let page3 = WebPage(title: "", url: URL(string: "www.page3.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)

        sut.didLoadForwardList([page1, page2, page3])

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
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
        var windowState: WindowPresentableModel?
        let page1 = WebPage(title: "page1 title", url: URL(string: "www.page1.com")!, date: Date())
        let page2 = WebPage(title: nil, url: URL(string: "www.page2.com")!, date: Date())
        sut.didUpdatePresentableModel = { windowState = $0 }
        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didLoadForwardList([page1, page2])

        sut.didDismissBackForwardList()

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertNil(windowState!.progressBarValue)
        XCTAssertNil(windowState!.forwardList)
        XCTAssertNil(windowState!.backList)
    }

    func test_didUpdateProgressBar_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(0.45)

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertEqual(windowState!.progressBarValue, 0.45)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueIsOne_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(1)

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertEqual(windowState!.progressBarValue, nil)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didUpdateProgressBar(1.5)

        XCTAssertNil(windowState!.urlHost)
        XCTAssertNil(windowState!.fullURL)
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showReloadButton)
        XCTAssertFalse(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertFalse(windowState!.showStopButton)
        XCTAssertEqual(windowState!.progressBarValue, nil)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectWindowState() {
        let (sut, _) = makeSUT()
        var windowState: WindowPresentableModel?
        sut.didUpdatePresentableModel = { windowState = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(windowState!.urlHost, "some-url.com")
        XCTAssertEqual(windowState!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(windowState!.showCancelButton)
        XCTAssertFalse(windowState!.showClearButton)
        XCTAssertTrue(windowState!.showStopButton)
        XCTAssertFalse(windowState!.showReloadButton)
        XCTAssertTrue(windowState!.showSiteProtection)
        XCTAssertTrue(windowState!.isWebsiteProtected)
        XCTAssertTrue(windowState!.showWebView)
        XCTAssertFalse(windowState!.canGoBack)
        XCTAssertFalse(windowState!.canGoForward)
        XCTAssertEqual(windowState!.progressBarValue, 0.45)
        XCTAssertNil(windowState!.backList)
        XCTAssertNil(windowState!.forwardList)
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

