import core_web_browser

class MenuComposer {

    func makeViewModel(webView: WebEngineContract) -> MenuViewModel {
        return MenuViewModel(webView: webView)        
    }
}
