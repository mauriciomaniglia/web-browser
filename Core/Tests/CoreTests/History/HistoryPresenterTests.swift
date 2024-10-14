import XCTest
import Core

class HistoryPresenterTests: XCTestCase {

    func test_didLoadPages_deliversCorrectState() {
        let sut = makeSUT()

        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let page1 = WebPage(title: "title 1", url: URL(string: "http://page1.com")!, date: today)
        let page2 = WebPage(title: "title 2", url: URL(string: "http://page2.com")!, date: today)
        let page3 = WebPage(title: "", url: URL(string: "http://page3.com")!, date: yesterday)

        var model: HistoryPresentableModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didLoadPages([page1, page2, page3])

        XCTAssertEqual(model.list?.first?.pages[0].title, "12:00 - title 1")
        XCTAssertEqual(model.list?.first?.pages[0].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(model.list?.first?.pages[1].title, "12:00 - title 2")
        XCTAssertEqual(model.list?.first?.pages[1].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(model.list?.last?.pages[0].title, "12:00 - http://page3.com")
        XCTAssertEqual(model.list?.last?.pages[0].url, URL(string:"http://page3.com")!)
    }

    // MARK: - Helpers

    private func makeSUT() -> HistoryPresenter {
        return HistoryPresenter()
    }
}
