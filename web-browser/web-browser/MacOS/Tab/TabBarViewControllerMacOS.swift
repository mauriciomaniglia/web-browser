#if canImport(AppKit)
import SwiftUI

class TabBarViewController: NSViewController {
    private var hostingControllers: [NSHostingController<TabContentViewMacOS>] = []
    private var tabViewController: NSTabViewController!
    private var tabBarHostingView: NSHostingView<TabBarView>!

    private let tabFactory: TabViewFactory

    private var currentIndex: Int {
        get { tabViewController.selectedTabViewItemIndex }
        set {
            guard newValue != currentIndex,
                  hostingControllers.indices.contains(newValue) else { return }
            tabViewController.selectedTabViewItemIndex = newValue
        }
    }

    init(tabFactory: TabViewFactory) {
        self.tabFactory = tabFactory
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

        if tabFactory.tabs.isEmpty {
            addNewTab()
        } else {
            for tab in tabFactory.tabs {
                let tabContent = tab.view as! TabContentViewMacOS
                addNewTab(tabContent)
            }
        }

        selectTab(at: tabFactory.selectedTabIndex)
    }

    private func setupTabViewController() {
        tabViewController = NSTabViewController()
        tabViewController.tabStyle = .unspecified
        tabViewController.transitionOptions = []

        addChild(tabViewController)
        view.addSubview(tabViewController.view)

        tabViewController.view.translatesAutoresizingMaskIntoConstraints = false

        // We'll set top constraint later, after tab bar
        NSLayoutConstraint.activate([
            tabViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Observe selection changes on NSTabViewController
        tabViewController.addObserver(self, forKeyPath: "selectedTabViewItemIndex", options: [.new], context: nil)
    }

    private func setupTabBar() {
        let tabBarView = TabBarView(
            tabFactory: tabFactory,
            currentIndex: Binding(
                get: { self.currentIndex },
                set: { _ in } // Will be updated in refresh
            ),
            onAdd: { [weak self] in self?.addNewTab() },
            onClose: { [weak self] index in self?.closeTab(at: index) },
            onSelect: { [weak self] index in self?.selectTab(at: index) }
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
            tabFactory: tabFactory,
            currentIndex: Binding(
                get: { self.currentIndex },
                set: { [weak self] newValue in
                    self?.selectTab(at: newValue)
                }
            ),
            onAdd: { [weak self] in self?.addNewTab() },
            onClose: { [weak self] index in self?.closeTab(at: index) },
            onSelect: { [weak self] index in self?.selectTab(at: index) }
        )
    }

    func addNewTab(_ tabContent: TabContentViewMacOS? = nil) {
        let content = tabContent ?? (tabFactory.createNewTab().view as! TabContentViewMacOS)
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

        tabFactory.tabs.remove(at: index)

        // Adjust current index if needed
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

    // MARK: - KVO
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
#endif
