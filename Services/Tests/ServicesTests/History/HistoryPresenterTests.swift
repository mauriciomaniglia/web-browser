import XCTest
import Services

class HistoryPresenterTests: XCTestCase {

    func test_didLoadPages_deliversCorrectState() {
        let sut = makeSUT()

        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let page1 = HistoryPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        let page2 = HistoryPageModel(title: "title 2", url: URL(string: "http://page2.com")!, date: today)
        let page3 = HistoryPageModel(title: "", url: URL(string: "http://page3.com")!, date: yesterday)

        var model: HistoryPresenter.Model!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didLoadPages([page1, page2, page3])

        XCTAssertEqual(model.list?.first?.pages[0].title, "12:00 - title 2")
        XCTAssertEqual(model.list?.first?.pages[0].url, URL(string:"http://page2.com")!)
        XCTAssertEqual(model.list?.first?.pages[1].title, "07:00 - title 1")
        XCTAssertEqual(model.list?.first?.pages[1].url, URL(string:"http://page1.com")!)
        XCTAssertEqual(model.list?.last?.pages[0].title, "12:00 - http://page3.com")
        XCTAssertEqual(model.list?.last?.pages[0].url, URL(string:"http://page3.com")!)
    }

    // MARK: - Helpers

    private func makeSUT() -> HistoryPresenter {
        return HistoryPresenter()
    }
}
