import XCTest
@testable import web_browser
import core_web_browser

class WindowPresenterTests: XCTestCase {

    func test_didStartNewWindow_deliversCorrectValues() {
        let sut = WindowPresenter()
        var receivedResult: WindowPresentableModel?
        sut.didUpdatePresentableModel = { receivedResult = $0 }

        sut.didStartNewWindow()

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertTrue(receivedResult!.showClearButton)
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

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertTrue(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertNil(receivedResult!.urlHost)
        XCTAssertNil(receivedResult!.fullURL)
        XCTAssertFalse(receivedResult!.showClearButton)
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

        XCTAssertEqual(receivedResult!.urlHost, "some-url.com")
        XCTAssertEqual(receivedResult!.fullURL, "http://some-url.com/some-random-path/123")
        XCTAssertFalse(receivedResult!.showClearButton)
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
