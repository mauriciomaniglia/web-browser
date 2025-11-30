#if canImport(UIKit)
import UIKit
import SwiftUI

class TabBarViewController<Content: View>: UIViewController {
    private var hostingControllers: [UIHostingController<Content>] = []
    private var currentIndex: Int = 0
    private var currentController: UIHostingController<Content>?
    private let contentProvider: () -> Content
    private var tabBarHostingController: UIHostingController<TabBarView>!

    private let tabFactory: TabViewFactory

    init(tabFactory: TabViewFactory, contentProvider: @escaping () -> Content) {
        self.tabFactory = tabFactory
        self.contentProvider = contentProvider
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTabBar()
        addNewTab()
    }

    private func setupTabBar() {
        let tabBarView = TabBarView(
            tabFactory: tabFactory,
            currentIndex: Binding(
                get: { self.currentIndex },
                set: { newValue in
                    self.currentIndex = newValue
                    self.showController(self.hostingControllers[newValue])
                }
            ),
            onAdd: { [weak self] in self?.addNewTab() },
            onClose: { [weak self] index in self?.closeTab(at: index) },
            onSelect: { [weak self] index in
                self?.currentIndex = index
                self?.showController(self!.hostingControllers[index])
            }
        )

        tabBarHostingController = UIHostingController(rootView: tabBarView)
        addChild(tabBarHostingController)
        view.addSubview(tabBarHostingController.view)
        tabBarHostingController.didMove(toParent: self)

        tabBarHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabBarHostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabBarHostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarHostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarHostingController.view.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func refreshTabBar() {
        tabBarHostingController.rootView = TabBarView(
            tabFactory: tabFactory,
            currentIndex: Binding(
                get: { self.currentIndex },
                set: { newValue in
                    self.currentIndex = newValue
                    self.showController(self.hostingControllers[newValue])
                    self.refreshTabBar()
                }
            ),
            onAdd: { [weak self] in self?.addNewTab() },
            onClose: { [weak self] index in self?.closeTab(at: index) },
            onSelect: { [weak self] index in
                self?.currentIndex = index
                self?.showController(self!.hostingControllers[index])
                self?.refreshTabBar()
            }
        )
    }

    func addNewTab() {
        let newContent = contentProvider()
        let hostingController = UIHostingController(rootView: newContent)
        hostingControllers.append(hostingController)
        currentIndex = hostingControllers.count - 1
        refreshTabBar()
        showController(hostingController)
    }

    func closeTab(at index: Int) {
        guard hostingControllers.indices.contains(index) else { return }
        hostingControllers.remove(at: index)
        if currentIndex >= hostingControllers.count {
            currentIndex = max(0, hostingControllers.count - 1)
        }
        refreshTabBar()
        if hostingControllers.isEmpty {
            currentController?.view.removeFromSuperview()
            currentController = nil
        } else {
            showController(hostingControllers[currentIndex])
        }
    }

    private func showController(_ controller: UIHostingController<Content>) {
        currentController?.view.removeFromSuperview()
        currentController = controller
        addChild(controller)
        view.addSubview(controller.view)
        controller.didMove(toParent: self)

        controller.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: tabBarHostingController.view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
#endif
