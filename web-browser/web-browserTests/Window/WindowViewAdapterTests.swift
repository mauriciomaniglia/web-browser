import XCTest
@testable import web_browser
@testable import Services

class WindowViewAdapterTests: XCTestCase {

    func test_updateViewModel_updatesAllValuesCorrectly() {
        let viewModel = WindowViewModel(historyViewModel: HistoryViewModel(), bookmarkViewModel: BookmarkViewModel())
        let sut = WindowViewAdapter(webView: WebViewSpy(), viewModel: viewModel, bookmarkViewModel: BookmarkViewModel())

        let model = WindowPresentableModel(
            title: "Apple Airpods",
            urlHost: "www.apple.com",
            fullURL: "http://apple.com/airpods",
            showCancelButton: true,
            showClearButton: true,
            showStopButton: true,
            showReloadButton: true,
            showSiteProtection: true,
            isWebsiteProtected: true,
            showWebView: true,
            canGoBack: true,
            canGoForward: true,
            progressBarValue: 0.5, 
            backList: [WindowPresentableModel.Page(title: "back page title", url: "http://back-page.com")],
            forwardList: [WindowPresentableModel.Page(title: "forward page title", url: "http://forward-page.com")])

        sut.updateViewModel(model)

        XCTAssertEqual(sut.viewModel.title, model.title)
        XCTAssertEqual(sut.viewModel.urlHost, model.urlHost)
        XCTAssertEqual(sut.viewModel.fullURL, model.fullURL)
        XCTAssertEqual(sut.viewModel.showStopButton, model.showStopButton)
        XCTAssertEqual(sut.viewModel.showReloadButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showClearButton, model.showReloadButton)
        XCTAssertEqual(sut.viewModel.showSiteProtection, model.showSiteProtection)
        XCTAssertEqual(sut.viewModel.isWebsiteProtected, model.isWebsiteProtected)
        XCTAssertEqual(sut.viewModel.isBackButtonDisabled, !model.canGoBack)
        XCTAssertEqual(sut.viewModel.isForwardButtonDisabled, !model.canGoForward)
        XCTAssertEqual(sut.viewModel.progressBarValue, model.progressBarValue)
        XCTAssertEqual(sut.viewModel.backList.first?.title, model.backList?.first?.title)
        XCTAssertEqual(sut.viewModel.backList.first?.url, model.backList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
        XCTAssertEqual(sut.viewModel.forwardList.first?.title, model.forwardList?.first?.title)
        XCTAssertEqual(sut.viewModel.forwardList.first?.url, model.forwardList?.first?.url)
        XCTAssertTrue(sut.viewModel.showBackList)
    }
}
