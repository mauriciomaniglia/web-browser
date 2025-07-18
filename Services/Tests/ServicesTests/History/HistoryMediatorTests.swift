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
