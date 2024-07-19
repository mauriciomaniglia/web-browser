import XCTest
import core_web_browser
@testable import web_browser

class MenuPresenterTests: XCTestCase {

    func test_didOpenMenuView_deliversCorrectModel() {
        let sut = makeSUT()
        var model: MenuModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didOpenMenuView()

        XCTAssertTrue(model.showMenu)
        XCTAssertFalse(model.showHistory)
    }

    func test_didOpenHistoryView_deliversCorrectModel() {
        let sut = makeSUT()
        var model: MenuModel!
        sut.didUpdatePresentableModel = { model = $0 }

        sut.didOpenHistoryView()

        XCTAssertFalse(model.showMenu)
        XCTAssertTrue(model.showHistory)
    }

    // MARK: - Helpers

    private func makeSUT() -> MenuPresenter {
        return MenuPresenter()        
    }
}
