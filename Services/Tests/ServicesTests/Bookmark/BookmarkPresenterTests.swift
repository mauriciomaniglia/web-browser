import XCTest
@testable import Services

class BookmarkPresenterTests: XCTestCase {

    func test_mapBookmarks_returnsBookmark() {
        let (model1, presentableModel1) = makeModel(title: "title 1", urlString: "http://example1.com")
        let (model2, presentableModel2) = makeModel(title: "title 2", urlString: "http://example2.com")
        let (sut, delegate) = makeSUT()

        sut.mapBookmarks(from: [model1, model2])

        XCTAssertEqual(delegate.receivedMessages, [.didUpdatePresentableModels([presentableModel1, presentableModel2])])
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: BookmarkPresenter, delegate: BookmarkPresenterDelegateMock) {
        let sut = BookmarkPresenter()
        let delegate = BookmarkPresenterDelegateMock()
        sut.delegate = delegate

        return (sut, delegate)
    }

    private func makeModel(title: String, urlString: String) -> (model: BookmarkModel, presentableModel: BookmarkPresenter.Model) {
        let model = BookmarkModel(title: title, url: URL(string: urlString)!)
        let presentableModel = BookmarkPresenter.Model(id: model.id, title: model.title!, url: model.url)

        return (model, presentableModel)
    }
}

private class BookmarkPresenterDelegateMock: BookmarkPresenterDelegate {
    enum Message: Equatable {
        case didUpdatePresentableModels(_ models: [BookmarkPresenter.Model])
    }

    var receivedMessages = [Message]()

    func didUpdatePresentableModels(_ models: [BookmarkPresenter.Model]) {
        receivedMessages.append(.didUpdatePresentableModels(models))
    }
}
