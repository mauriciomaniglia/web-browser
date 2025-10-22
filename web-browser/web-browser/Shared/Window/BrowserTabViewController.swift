#if canImport(UIKit)
import UIKit
import SwiftUI

class BrowserTabViewController<Content: View>: UIViewController {
    private var hostingControllers: [UIHostingController<Content>] = []
    private var currentIndex: Int = 0
    private let tabScrollView = UIScrollView()
    private let tabStackView = UIStackView()
    private let addButton = UIButton(type: .system)
    private var currentController: UIHostingController<Content>?
    private let contentProvider: () -> Content

    init(contentProvider: @escaping () -> Content) {
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

    // MARK: - Setup Tab Bar
    private func setupTabBar() {
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(tabScrollView)

        tabStackView.axis = .horizontal
        tabStackView.spacing = 8
        tabStackView.alignment = .fill
        tabStackView.translatesAutoresizingMaskIntoConstraints = false
        tabScrollView.addSubview(tabStackView)

        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            tabScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tabScrollView.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -4),
            tabScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            tabScrollView.heightAnchor.constraint(equalToConstant: 40),

            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addButton.centerYAnchor.constraint(equalTo: tabScrollView.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32),

            tabStackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor),
            tabStackView.trailingAnchor.constraint(equalTo: tabScrollView.trailingAnchor),
            tabStackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor),
            tabStackView.bottomAnchor.constraint(equalTo: tabScrollView.bottomAnchor),
            tabStackView.heightAnchor.constraint(equalTo: tabScrollView.heightAnchor)
        ])
    }

    // MARK: - Tab Button Creation
    private func createTabButton(title: String, index: Int) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 8
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.backgroundColor = index == currentIndex ? UIColor.systemGray5 : UIColor.systemBackground
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("×", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        closeButton.tag = index
        closeButton.addTarget(self, action: #selector(closeTabButtonTapped(_:)), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
        container.addGestureRecognizer(tapGesture)
        container.tag = index

        let stack = UIStackView(arrangedSubviews: [label, closeButton])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            stack.centerYAnchor.constraint(equalTo: container.centerYAnchor)
        ])

        container.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        return container
    }

    private func refreshTabBar() {
        tabStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (index, _) in hostingControllers.enumerated() {
            let title = "Tab \(index + 1)"
            let tabView = createTabButton(title: title, index: index)
            tabStackView.addArrangedSubview(tabView)
        }
    }

    // MARK: - Content Management
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
            controller.view.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor, constant: 4),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func addButtonTapped() {
        addNewTab()
    }

    @objc private func closeTabButtonTapped(_ sender: UIButton) {
        closeTab(at: sender.tag)
    }

    @objc private func tabTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        currentIndex = view.tag
        refreshTabBar()
        showController(hostingControllers[currentIndex])
    }
}
#endif
