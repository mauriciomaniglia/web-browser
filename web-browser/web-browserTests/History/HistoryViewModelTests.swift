import XCTest
@testable import web_browser

class HistoryViewModelTests: XCTestCase {

    func test_selectedPages_when_initialized_is_empty() {
        let sut = HistoryViewModel()
        XCTAssertEqual(sut.selectedPages, [])
    }

    func test_selectedPages_has_one_page_when_one_page_is_selected() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()

        XCTAssertEqual(sut.selectedPages, [sut.historyList[0].pages[0]])
    }

    func test_selectedPages_has_no_pages_when_toggles_selection() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()
        sut.historyList[0].pages[0].select()

        XCTAssertEqual(sut.selectedPages, [])
    }

    func test_deselectAllPages_deselects_selectable_pages() {
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

    func test_deleteSelectedPages_deletes_selected_pages() {
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

    func test_deleteAllPages_deletes_all_pages() {
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
        return .init(id: UUID(), title: "Any Title", url: "Any URL")
    }
}
