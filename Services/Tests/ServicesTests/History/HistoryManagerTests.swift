import Foundation
import Testing
@testable import Services

@MainActor
@Suite
struct HistoryManagerTests {

    @Test("Opening history groups pages by day and sorts today by time")
    func didOpenHistoryView_deliversCorrectResult() {
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

        let presentableModel = sut.didOpenHistoryView()

        #expect(history.receivedMessages == [.getPages])
        #expect(presentableModel.list?.first?.pages[0].title == "12:00 - title 2")
        #expect(presentableModel.list?.first?.pages[0].url == URL(string:"http://page2.com")!)
        #expect(presentableModel.list?.first?.pages[1].title == "07:00 - title 1")
        #expect(presentableModel.list?.first?.pages[1].url == URL(string:"http://page1.com")!)
        #expect(presentableModel.list?.last?.pages[0].title == "12:00 - http://page3.com")
        #expect(presentableModel.list?.last?.pages[0].url == URL(string:"http://page3.com")!)
    }

    @Test("Searching with a term queries the store and returns formatted results")
    func didSearchTerm_deliversCorrectResult() async {
        let (sut, history) = makeSUT()
        let calendar = Calendar.current
        let time = DateComponents(hour: 12, minute: 0, second: 0)
        let earlyToday = calendar.date(bySettingHour: time.hour!-5, minute: time.minute!, second: time.second!, of: Date())!
        let page = WebPageModel(title: "title 1", url: URL(string: "http://page1.com")!, date: earlyToday)
        history.mockWebPages = [page]

        let presentableModel = await sut.didSearchTerm("test")

        #expect(history.receivedMessages == [.getPagesByTerm("test")])
        #expect(presentableModel.list?.first?.pages[0].title == "07:00 - title 1")
        #expect(presentableModel.list?.first?.pages[0].url == URL(string:"http://page1.com")!)
    }

    @Test("Searching with an empty term returns no results and fetches all pages")
    func didSearchTerm_withEmptyTerm_sendsCorrectMessage() async {
        let (sut, history) = makeSUT()

        let presentableModel = await sut.didSearchTerm("")

        #expect(presentableModel.list == [])
        #expect(history.receivedMessages == [.getPages])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryManager<HistoryStoreMock>, historyStore: HistoryStoreMock) {
        let historyStore = HistoryStoreMock()
        let sut = HistoryManager(historyStore: historyStore)

        return (sut, historyStore)
    }
}
