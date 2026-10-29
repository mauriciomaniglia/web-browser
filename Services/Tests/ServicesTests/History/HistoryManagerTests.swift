import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct HistoryManagerTests {

    @Test("Opening history groups pages by day and sorts today by time")
    func loadViewData_deliversCorrectResult() {
        let (sut, history) = makeSUT()
        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let today = calendar.date(bySettingHour: time.hour!, minute: time.minute!, second: time.second!, of: Date())!
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let page1 = WebPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        let page2 = WebPageModel(title: "title 2", url: URL(string: "http://page2.com")!, date: today)
        let page3 = WebPageModel(title: "", url: URL(string: "http://page3.com")!, date: yesterday)
        history.mockWebPages = [page1, page2, page3]

        let viewData = sut.loadViewData(from: "test")

        #expect(history.receivedMessages == [.getPages(date: nil, query: "test")])
        #expect(viewData.list?.first?.pages[0].title == "12:00 - title 2")
        #expect(viewData.list?.first?.pages[0].url == URL(string:"http://page2.com")!)
        #expect(viewData.list?.first?.pages[1].title == "07:00 - title 1")
        #expect(viewData.list?.first?.pages[1].url == URL(string:"http://page1.com")!)
        #expect(viewData.list?.last?.pages[0].title == "12:00 - http://page3.com")
        #expect(viewData.list?.last?.pages[0].url == URL(string:"http://page3.com")!)
    }

    @Test("Searching with a term queries the store and returns formatted results")
    func loadViewData_withNonEmptyQuery_deliversCorrectResult() {
        let (sut, history) = makeSUT()
        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let page = WebPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        history.mockWebPages = [page]

        let viewData = sut.loadViewData(from: "test")

        #expect(history.receivedMessages == [.getPages(date: nil, query: "test")])
        #expect(viewData.list?.first?.pages[0].title == "07:00 - title 1")
        #expect(viewData.list?.first?.pages[0].url == URL(string:"http://page1.com")!)
    }

    @Test("Searching with an empty term returns no results and fetches all pages")
    func loadViewData_withEmptyTerm_sendsCorrectMessage() {
        let (sut, history) = makeSUT()

        let viewData = sut.loadViewData(from: "")

        #expect(viewData.list == [])
        #expect(history.receivedMessages == [.getPages(date: nil, query: nil)])
    }

    @Test("Cleaning the history removes previous search data")
    func clearHistory_removesPreviousSearchData() {
        let (sut, history) = makeSUT()
        let page = WebPageModel(title: "any title", url: URL(string: "http://example.com")!, date: .now)
        history.mockWebPages = [page]

        _ = sut.loadViewData(from: "some query")
        sut.clearHistory()

        #expect(sut.pages.isEmpty)
        #expect(sut.lastQuery.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryManager<HistoryStoreMock>, historyStore: HistoryStoreMock) {
        let historyStore = HistoryStoreMock()
        let sut = HistoryManager(store: historyStore)

        return (sut, historyStore)
    }
}
