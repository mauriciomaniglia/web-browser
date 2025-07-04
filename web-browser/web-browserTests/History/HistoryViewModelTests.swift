import XCTest
@testable import web_browser

class HistoryViewModelTests: XCTestCase {

    func test_selectedPages_when_initialized_is_empty() {
        let sut = HistoryViewModel()
        XCTAssertEqual(sut.selectedPages, [])
    }

    func test_selectedPages_makesCorrectSelection() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()

        XCTAssertEqual(sut.selectedPages, [sut.historyList[0].pages[0]])
    }

    func test_selectedPages_whenSelectingTwice_removesSelection() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()
        sut.historyList[0].pages[0].select()

        XCTAssertEqual(sut.selectedPages, [])
    }

    func test_deselectAllPages_removesSelectedPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]

        sut.historyList[0].pages[0].select()
        sut.historyList[1].pages[0].select()

        XCTAssertEqual(sut.selectedPages, [
            sut.historyList[0].pages[0],
            sut.historyList[1].pages[0]
        ])

        sut.deselectAllPages()

        XCTAssertEqual(sut.selectedPages, [])
        XCTAssertEqual(sut.historyList, [section1, section2, section3])
    }

    func test_deleteSelectedPages_removesSelectedPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]
        
        sut.historyList[0].pages[0].select()
        sut.historyList[1].pages[0].select()

        sut.deleteSelectedPages()

        XCTAssertEqual(sut.selectedPages, [])
        XCTAssertEqual(sut.historyList, [section3])
    }

    func test_deleteAllPages_removesAllPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]
        
        sut.deleteAllPages()
        
        XCTAssertEqual(sut.historyList, [])
    }

    // MARK: - Helpers

    private func anySection() -> HistoryViewModel.Section {
        return .init(title: "Any Title", pages: [anyPage()])
    }

    private func anyPage() -> HistoryViewModel.Page {
        return .init(id: UUID(), title: "Any Title", url: URL(string: "http://any-url.com")!)
    }
}
