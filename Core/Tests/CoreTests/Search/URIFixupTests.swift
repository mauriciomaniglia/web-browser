import XCTest
import Core

class URIFixupTests: XCTestCase {
    func test_getURL_forValidURLs_deliversCorrectResult() {
        checkValidURL("http://www.mozilla.org", afterFixup: "http://www.mozilla.org")
        checkValidURL("about:", afterFixup: "about:")
        checkValidURL("about:config", afterFixup: "about:config")
        checkValidURL("about: config", afterFixup: "about:%20config")
        checkValidURL("file:///f/o/o", afterFixup: "file:///f/o/o")
        checkValidURL("ftp://ftp.mozilla.org", afterFixup: "ftp://ftp.mozilla.org")
        checkValidURL("foo.bar", afterFixup: "http://foo.bar")
        checkValidURL(" foo.bar ", afterFixup: "http://foo.bar")
        checkValidURL("[::1]:80", afterFixup: "http://[::1]:80")
        checkValidURL("[2a04:4e42:400::288]", afterFixup: "http://[2a04:4e42:400::288]")
        checkValidURL("[2a04:4e42:600::288]:80", afterFixup: "http://[2a04:4e42:600::288]:80")
        checkValidURL("[2605:2700:0:3::4713:93e3]:443", afterFixup: "http://[2605:2700:0:3::4713:93e3]:443")
        checkValidURL("[::192.9.5.5]", afterFixup: "http://[::192.9.5.5]")
        checkValidURL("[::192.9.5.5]:80", afterFixup: "http://[::192.9.5.5]:80")
        checkValidURL("[::192.9.5.5]/png", afterFixup: "http://[::192.9.5.5]/png")
        checkValidURL("[::192.9.5.5]:80/png", afterFixup: "http://[::192.9.5.5]:80/png")
        checkValidURL("192.168.2.1", afterFixup: "http://192.168.2.1")
        checkValidURL("brave.io", afterFixup: "http://brave.io")
        checkValidURL("brave.new.world", afterFixup: "http://brave.new.world")
        checkValidURL("brave.new.world.test", afterFixup: "http://brave.new.world.test")
        checkValidURL("brave.new.world.test.io", afterFixup: "http://brave.new.world.test.io")
        checkValidURL("brave.new.world.test.whatever.io", afterFixup: "http://brave.new.world.test.whatever.io")
        checkValidURL("http://2130706433:8000/", afterFixup: "http://2130706433:8000/")
        checkValidURL("http://127.0.0.1:8080", afterFixup: "http://127.0.0.1:8080")
        checkValidURL("http://127.0.1", afterFixup: "http://127.0.1")
        checkValidURL("http://127.1", afterFixup: "http://127.1")
        checkValidURL("http://127.1:8000", afterFixup: "http://127.1:8000")
        checkValidURL("http://1.1:80", afterFixup: "http://1.1:80")
    }
    
    func test_getURL_forInvalidURLs_deliversCorrectResult() {
        // Check invalid URLs. These are passed along to the default search engine.
        checkInvalidURL("foobar")
        checkInvalidURL("foo bar")
        checkInvalidURL("mozilla. org")
        checkInvalidURL("123")
        checkInvalidURL("a/b")
        checkInvalidURL("创业咖啡")
        checkInvalidURL("创业咖啡 中国")
        checkInvalidURL("创业咖啡. 中国")
        checkInvalidURL("data:text/html;base64,SGVsbG8gV29ybGQhCg==")
        checkInvalidURL("data://https://www.example.com,fake example.com")
        checkInvalidURL("1.2.3")
        checkInvalidURL("1.1")
        checkInvalidURL("127.1")
        checkInvalidURL("127.1.1")

        // Check invalid quoted URLs, emails, and quoted domains.
        // These are passed along to the default search engine.
        checkInvalidURL(#""123"#)
        checkInvalidURL(#""123""#)
        checkInvalidURL(#""ftp.mozilla.org"#)
        checkInvalidURL(#""ftp.mozilla.org""#)
        checkInvalidURL(#"https://"ftp.mozilla.org""#)
        checkInvalidURL(#"https://"ftp.mozilla.org"#)
        checkInvalidURL("foo@brave.com")
        checkInvalidURL("\"foo@brave.com")
        checkInvalidURL("\"foo@brave.com\"")
        checkInvalidURL(#""创业咖啡.中国"#)
        checkInvalidURL(#""创业咖啡.中国""#)
        checkInvalidURL("foo:5000")
        checkInvalidURL("http://::192.9.5.5")
        checkInvalidURL("http://::192.9.5.5:8080")
    }
    
    // MARK: - Helpers

    private func checkValidURL(_ beforeFixup: String, afterFixup: String) {
        XCTAssertEqual(URIFixup.getURL(beforeFixup)!.absoluteString, afterFixup)
    }

    private func checkInvalidURL(_ beforeFixup: String) {
        XCTAssertNil(URIFixup.getURL(beforeFixup))
    }
}
