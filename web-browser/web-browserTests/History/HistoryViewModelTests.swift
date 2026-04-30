import Foundation
import Testing
@testable import web_browser

@MainActor
@Suite
struct HistoryViewModelTests {

    @Test("selectedPages is empty on initialization")
    func selectedPagesWhenInitialized() {
        let sut = HistoryViewModel()
        #expect(sut.selectedPages == [])
    }

    @Test("Selecting a page adds it to selectedPages")
    func selectedPagesMakesCorrectSelection() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()

        #expect(sut.selectedPages == [sut.historyList[0].pages[0]])
    }

    @Test("Selecting the same page twice toggles selection off")
    func selectingPageTwiceRemovesSelection() {
        let anySection = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [anySection]

        sut.historyList[0].pages[0].select()
        sut.historyList[0].pages[0].select()

        #expect(sut.selectedPages == [])
    }

    @Test("deselectAllPages clears selection and preserves list")
    func deselectAllPagesRemovesSelectedPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]

        sut.historyList[0].pages[0].select()
        sut.historyList[1].pages[0].select()

        #expect(sut.selectedPages == [
            sut.historyList[0].pages[0],
            sut.historyList[1].pages[0]
        ])

        sut.deselectAllPages()

        #expect(sut.selectedPages == [])
        #expect(sut.historyList == [section1, section2, section3])
    }

    @Test("deleteSelectedPages removes selected and prunes empty sections")
    func deleteSelectedPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]
        
        sut.historyList[0].pages[0].select()
        sut.historyList[1].pages[0].select()

        sut.deleteSelectedPages()

        #expect(sut.selectedPages == [])
        #expect(sut.historyList == [section3])
    }

    @Test("deleteAllPages clears history list")
    func deleteAllPages() {
        let section1 = anySection()
        let section2 = anySection()
        let section3 = anySection()
        let sut = HistoryViewModel()
        sut.historyList = [section1, section2, section3]
        
        sut.deleteAllPages()
        
        #expect(sut.historyList == [])
    }

    // MARK: - Helpers

    private func anySection() -> HistoryViewModel.Section {
        return .init(title: "Any Title", pages: [anyPage()])
    }

    private func anyPage() -> HistoryViewModel.Page {
        return .init(id: UUID(), title: "Any Title", url: URL(string: "http://any-url.com")!)
    }
}
