import Core
import XCTest

class TestsHelpers: XCTestCase {
    
    func test_loadJsonContent_whenFileDoesNotExistReturnsNil() {
        XCTAssertNil(Helpers.loadJsonContent(filename: "fakeFile"))
    }

    func test_loadJsonContent_whenFileExistReturnsNonNil() {
        XCTAssertNotNil(Helpers.loadJsonContent(filename: "AnalyticsRules"))
    }
}
