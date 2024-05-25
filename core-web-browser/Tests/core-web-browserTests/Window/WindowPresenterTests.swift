import XCTest
import core_web_browser

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didStartNewWindow_deliversCorrectValuesWhenCallFromAnyPreviousState() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didStartEditing_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartEditing()

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertTrue(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didStartEditing_deliversCorrectValuesWithPageAlreadyLoaded() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didStartEditing()

        XCTAssertEqual(receivedResult!.pageURL, "some-url.com")
        XCTAssertTrue(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didEndEditing_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didEndEditing()

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertFalse(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didEndEditing_deliversCorrectValuesWithPageAlreadyLoaded() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didEndEditing()

        XCTAssertEqual(receivedResult!.pageURL, "some-url.com")
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didLoadPage_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)

        XCTAssertEqual(receivedResult!.pageURL, "some-url.com")
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertNil(receivedResult!.progressBarValue)
    }

    func test_didUpdateProgressBar_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(0.45)

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertTrue(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertEqual(receivedResult!.progressBarValue, 0.45)
    }

    func test_didUpdateProgressBar_whenValueIsOne_stopButtonAndProgressBarShouldNotBeVisible() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1)

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertEqual(receivedResult!.progressBarValue, nil)
    }

    func test_didUpdateProgressBar_whenValueGreaterThanOne_stopButtonAndProgressBarShouldNotBeVisible() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didUpdateProgressBar(1.5)

        XCTAssertNil(receivedResult!.pageURL)
        XCTAssertFalse(receivedResult!.showCancelButton)        
        XCTAssertTrue(receivedResult!.showReloadButton)
        XCTAssertFalse(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertFalse(receivedResult!.canGoBack)
        XCTAssertFalse(receivedResult!.canGoForward)
        XCTAssertFalse(receivedResult!.showStopButton)
        XCTAssertEqual(receivedResult!.progressBarValue, nil)
    }

    func test_didUpdateProgressBar_whenNavigationUpdates_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didLoadPage(url: URL(string:"http://some-url.com/some-random-path/123")!, canGoBack: true, canGoForward: true)
        sut.didUpdateProgressBar(0.45)

        XCTAssertEqual(receivedResult!.pageURL, "some-url.com")
        XCTAssertFalse(receivedResult!.showCancelButton)
        XCTAssertTrue(receivedResult!.showStopButton)
        XCTAssertFalse(receivedResult!.showReloadButton)
        XCTAssertTrue(receivedResult!.showSiteProtection)
        XCTAssertTrue(receivedResult!.isWebsiteProtected)
        XCTAssertTrue(receivedResult!.showWebView)
        XCTAssertTrue(receivedResult!.canGoBack)
        XCTAssertTrue(receivedResult!.canGoForward)
        XCTAssertEqual(receivedResult!.progressBarValue, 0.45)
    }
}
