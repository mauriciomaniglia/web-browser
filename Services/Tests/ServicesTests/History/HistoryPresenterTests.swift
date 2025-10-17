import XCTest
import Services

class HistoryPresenterTests: XCTestCase {

    func test_didLoadPages_deliversCorrectState() {
        let (sut, delegate) = makeSUT()

        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let page1 = HistoryPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        let page2 = HistoryPageModel(title: "title 2", url: URL(string: "http://page2.com")!, date: today)
        let page3 = HistoryPageModel(title: "", url: URL(string: "http://page3.com")!, date: yesterday)

        sut.didLoadPages([page1, page2, page3])

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModel])
        XCTAssertEqual(delegate.presentableModel!.list?.first?.pages[0].title, "12:00 - title 2")
        XCTAssertEqual(delegate.presentableModel!.list?.first?.pages[0].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(delegate.presentableModel!.list?.first?.pages[1].title, "07:00 - title 1")
        XCTAssertEqual(delegate.presentableModel!.list?.first?.pages[1].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(delegate.presentableModel!.list?.last?.pages[0].title, "12:00 - http://page3.com")
        XCTAssertEqual(delegate.presentableModel!.list?.last?.pages[0].url, URL(string:"http://page3.com")!)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryPresenter, delegate: HistoryPresenterDelegateMock) {
        let sut = HistoryPresenter()
        let delegate = HistoryPresenterDelegateMock()
        sut.delegate = delegate

        return (sut, delegate)
    }
}

private class HistoryPresenterDelegateMock: HistoryPresenterDelegate {
    enum Message {
        case didUpdatePresentableModel
    }

    var receivedMessages = [Message]()
    var presentableModel: HistoryPresenter.Model?

    func didUpdatePresentableModel(_ model: HistoryPresenter.Model) {
        receivedMessages.append(.didUpdatePresentableModel)
        presentableModel = model
    }
}
