import XCTest
import Services

class HistoryMediatorTests: XCTestCase {

    func test_didOpenHistoryView_sendsCorrectMessage() {
        let (sut, presenter, history) = makeSUT()

        sut.didOpenHistoryView()

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPages])
    }

    func test_didSearchTerm_sendsCorrectMessage() {
        let (sut, presenter, history) = makeSUT()

        sut.didSearchTerm("test")

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPagesByTerm("test")])
    }

    func test_didSearchTerm_withEmptyTerm_sendsCorrectMessage() {
        let (sut, presenter, history) = makeSUT()

        sut.didSearchTerm("")

        XCTAssertEqual(presenter.receivedMessages, [.didLoadPages])
        XCTAssertEqual(history.receivedMessages, [.getPages])
    }

    func test_didTapDeletePages_sendsCorrectMessage() {
        let (sut, presenter, history) = makeSUT()
        let page1ID = UUID()
        let page2ID = UUID()

        sut.didTapDeletePages([page1ID, page2ID])
        
        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [.deletePages([page1ID, page2ID])])
    }

    func test_didTapDeleteAllPages_sendsCorrectMessage() {
        let (sut, presenter, history) = makeSUT()

        sut.didTapDeleteAllPages()

        XCTAssertEqual(presenter.receivedMessages, [])
        XCTAssertEqual(history.receivedMessages, [.deleteAllPages])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: HistoryMediator, presenter: HistoryPresenterSpy, historyStore: HistoryStoreMock) {
        let historyStore = HistoryStoreMock()
        let presenter = HistoryPresenterSpy()
        let sut = HistoryMediator(
            presenter: presenter,
            historyStore: historyStore)

        return (sut, presenter, historyStore)
    }
}
