import SwiftUI

class TabBarViewController: NSViewController {
    private var hostingControllers: [NSHostingController<TabContentView>] = []
    private var tabViewController: NSTabViewController!
    private var tabBarHostingView: NSHostingView<TabBarView>!
    private let tabManager: TabManager

    private var currentIndex: Int {
        get { tabViewController.selectedTabViewItemIndex }
        set {
            guard newValue != currentIndex,
                  hostingControllers.indices.contains(newValue) else { return }
            tabViewController.selectedTabViewItemIndex = newValue
        }
    }

    init(tabManager: TabManager) {
        self.tabManager = tabManager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabViewController()
        setupTabBar()

        if tabManager.tabs.isEmpty {
            addNewTab()
        } else {
            for tab in tabManager.tabs {
                let tabContent = tab.view
                addNewTab(tabContent)
            }
        }

        selectTab(at: tabManager.selectedTabIndex)
    }

    private func setupTabViewController() {
        tabViewController = NSTabViewController()
        tabViewController.tabStyle = .unspecified
        tabViewController.transitionOptions = []

        addChild(tabViewController)
        view.addSubview(tabViewController.view)

        tabViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tabViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tabViewController.addObserver(self, forKeyPath: "selectedTabViewItemIndex", options: [.new], context: nil)
    }

    private func setupTabBar() {
        let tabBarView = TabBarView(
            tabManager: tabManager,
            currentIndex: Binding(
                get: { self.currentIndex },
                set: { _ in }
            ),
            onAdd: { [unowned self] in self.addNewTab() },
            onClose: { [unowned self] index in self.closeTab(at: index) },
            onSelect: { [unowned self] index in self.selectTab(at: index) }
        )

        tabBarHostingView = NSHostingView(rootView: tabBarView)
        tabBarHostingView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tabBarHostingView)

        NSLayoutConstraint.activate([
            tabBarHostingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBarHostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarHostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        tabViewController.view.topAnchor.constraint(equalTo: tabBarHostingView.bottomAnchor).isActive = true
    }

    private func refreshTabBar() {
        tabBarHostingView.rootView = TabBarView(
            tabManager: tabManager,
            currentIndex: Binding(
                get: { [unowned self] in self.currentIndex },
                set: { [unowned self] newValue in
                    self.selectTab(at: newValue)
                }
            ),
            onAdd: { [unowned self] in self.addNewTab() },
            onClose: { [unowned self] index in self.closeTab(at: index) },
            onSelect: { [unowned self] index in self.selectTab(at: index) }
        )
    }

    func addNewTab(_ tabContent: TabContentView? = nil) {
        let content = tabContent ?? (tabManager.createNewTab().view)
        let hostingController = NSHostingController(rootView: content)
        hostingControllers.append(hostingController)

        let tabViewItem = NSTabViewItem(viewController: hostingController)
        tabViewItem.label = "Tab \(hostingControllers.count)"
        tabViewController.addTabViewItem(tabViewItem)

        currentIndex = hostingControllers.count - 1
        refreshTabBar()
    }

    func closeTab(at index: Int) {
        guard hostingControllers.indices.contains(index) else { return }

        let tabViewItem = tabViewController.tabView.tabViewItems[index]
        tabViewController.removeTabViewItem(tabViewItem)
        hostingControllers.remove(at: index)

        tabManager.closeTab(at: index)

        if currentIndex >= hostingControllers.count, !hostingControllers.isEmpty {
            currentIndex = hostingControllers.count - 1
        } else if hostingControllers.isEmpty {
            currentIndex = -1
        }

        refreshTabBar()
    }

    private func selectTab(at index: Int) {
        guard hostingControllers.indices.contains(index) else { return }
        currentIndex = index
        refreshTabBar()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "selectedTabViewItemIndex",
           let controller = object as? NSTabViewController,
           controller === tabViewController {
            refreshTabBar()
        }
    }

    deinit {
        tabViewController?.removeObserver(self, forKeyPath: "selectedTabViewItemIndex")
    }
}
