//
//  SlimFAQContentsViewController.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/19/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import UIKit

internal final class SlimFAQContentsViewController: UIViewController {

    @IBOutlet private weak var toolBar: UIToolbar!
    @IBOutlet private var closeBarButtonItem: UIBarButtonItem!
    @IBOutlet private var titleButtonItem: UIBarButtonItem!
    @IBOutlet private var refreshButtonItem: UIBarButtonItem!
    @IBOutlet private var collectionView: UICollectionView!
    
    lazy var backButtonItem: UIBarButtonItem = {
        let image = UIImage.slimFAQSDKBundle(imageNamed: "arrowBack")?.resizeImageWith(targetSize: CGSize(width: 20, height: 20))
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(SlimFAQContentsViewController.backButtonAction(_:)), for: .touchUpInside)
        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()
    
    private var viewModel: SlimFAQContentsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        viewModel.actions.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.actions.viewWillAppear()
        configureView()
    }
    
    private func configureView() {
        
        // configure ToolBar
        let maskPath = UIBezierPath(roundedRect: toolBar.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = toolBar.bounds
        maskLayer.path = maskPath.cgPath
        toolBar.layer.mask = maskLayer
        
        titleButtonItem.setTitleTextAttributes([.foregroundColor : UIColor.black], for: .normal)
        titleButtonItem.setTitleTextAttributes([.foregroundColor : UIColor.black], for: .highlighted)
        backButtonItem.title = nil
        backButtonItem.image = UIImage.slimFAQSDKBundle(imageNamed: "arrowBack")?.resizeImageWith(targetSize: CGSize(width: 25, height: 25))
        
        updateToolBarItems()
        
        collectionView.registerCell(LoadingStateCollectionViewCell.self)
        collectionView.registerCell(CategoryItemCollectionViewCell.self)
        collectionView.registerCell(EmptyStateCollectionViewCell.self)
        collectionView.registerCell(QuestionDetailsCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        switch viewModel.dataSource.screenMode {
        case .contents, .questions:
            collectionView.alwaysBounceVertical = true
        case .question:
            collectionView.isScrollEnabled = false
            collectionView.alwaysBounceVertical = false
        }
        
    }
    
    func updateToolBarItems(animated: Bool = false) {
        
        titleButtonItem.title = viewModel.dataSource.screenTitle
        refreshButtonItem.isEnabled = viewModel.dataSource.canRefreshData
        
        switch viewModel.dataSource.screenMode {
        case .contents:
            var items: [UIBarButtonItem] = []
            items += [closeBarButtonItem, .flexibleSpace, titleButtonItem, .flexibleSpace]
            if viewModel.dataSource.canRefreshData {
                items += [refreshButtonItem]
            }
            toolBar.setItems(items, animated: animated)
        case .questions, .question:
            var items: [UIBarButtonItem] = []
            items += [closeBarButtonItem, backButtonItem, .flexibleSpace, titleButtonItem, .flexibleSpace]
            if viewModel.dataSource.canRefreshData {
                items += [refreshButtonItem]
            }
            toolBar.setItems(items, animated: animated)
        }
    }
 
    @IBAction func closeButtonAction(_ sender: Any) {
        if let nc = navigationController {
            nc.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func refreshButtonAction(_ sender: Any) {
        viewModel.actions.didTouchRefreshButton()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        if let nc = navigationController {
            nc.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension SlimFAQContentsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionView
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let viewModel = viewModel else { return .zero }
        let boundingSize = collectionView.bounds.size
        
        let item = viewModel.dataSource.item(for: indexPath)
        switch item {
        case .loading(let vm):
            return LoadingStateCollectionViewCell.size(for: vm, boundingSize: boundingSize)
        case .category(let vm):
            return CategoryItemCollectionViewCell.size(for: vm, boundingWidth: boundingSize.width)
        case .question(let vm):
            return CategoryItemCollectionViewCell.size(for: vm, boundingWidth: boundingSize.width)
        case .empty(let vm):
            return EmptyStateCollectionViewCell.size(for: vm, boundingSize: boundingSize)
        case .questionDetails(let vm):
            return QuestionDetailsCollectionViewCell.size(for: vm, boundingSize: boundingSize)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.dataSource.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dataSource.numberOfItems(in: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel = viewModel else { fatalError() }

        switch viewModel.dataSource.item(for: indexPath) {
        case .loading:
            return collectionView.dequeueReusableCell(cellType: LoadingStateCollectionViewCell.self, forIndexPath: indexPath)
        case .category, .question:
            return collectionView.dequeueReusableCell(cellType: CategoryItemCollectionViewCell.self, forIndexPath: indexPath)
        case .empty:
            return collectionView.dequeueReusableCell(cellType: EmptyStateCollectionViewCell.self, forIndexPath: indexPath)
        case .questionDetails:
            return collectionView.dequeueReusableCell(cellType: QuestionDetailsCollectionViewCell.self, forIndexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { fatalError() }
        
        switch viewModel.dataSource.item(for: indexPath) {
        case .loading(let vm):
            guard let cell = cell as? LoadingStateCollectionViewCell else { return }
            cell.configure(with: vm)
        case .category(let vm):
            guard let cell = cell as? CategoryItemCollectionViewCell else { return }
            cell.configure(with: vm)
        case .question(let vm):
            guard let cell = cell as? CategoryItemCollectionViewCell else { return }
            cell.configure(with: vm)
        case .empty(let vm):
            guard let cell = cell as? EmptyStateCollectionViewCell else { return }
            cell.configure(with: vm)
        case .questionDetails(let vm):
            guard let cell = cell as? QuestionDetailsCollectionViewCell else { return }
            cell.configure(with: vm)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.dataSource.item(for: indexPath) {
        case .category(let vm):
            SlimFAQContentsViewController.present(from: self,
                                                  categoryName: vm.title,
                                                  questions: vm.questions,
                                                  animated: true,
                                                  completion: nil)
        case .question(let vm):
            SlimFAQContentsViewController.present(from: self,
                                                  questionMeta: vm.question,
                                                  animated: true,
                                                  completion: nil)
        case .loading, .empty, .questionDetails:
            return
        }
    }

}

extension SlimFAQContentsViewController: SlimFAQContentsViewModelDelegate {
    
    // MARK: SlimFAQContentsViewModelDelegate
    
    func slimFAQViewModelSetNeedsReload(viewModel: SlimFAQContentsViewModelType) {
        DispatchQueue.main.async {
            self.updateToolBarItems()
            self.collectionView.reloadData()
        }
    }
    
    func slimFAQViewModelDidReceiveAnError(viewModel: SlimFAQContentsViewModelType, errorMessage: String) {
        print(errorMessage)
    }
    
    func slimFAQViewModelSetBusy(busy: Bool, viewModel: SlimFAQContentsViewModelType) {
        DispatchQueue.main.async {
            self.refreshButtonItem.isEnabled = !busy
        }
    }
    
}

extension SlimFAQContentsViewController: StoryboardIdentifiable {}
extension SlimFAQContentsViewController {
    
    @discardableResult
    static func present(from sourceViewController: UIViewController, clientId: String, animated: Bool, completion: (()->Void)?) -> SlimFAQContentsViewController {
        
        let viewModel = SlimFAQContentsViewModel(mode: .contents(clientId: clientId))
        let targetViewController = UIStoryboard(storyboard: .Contents).instantiate(viewControllerType: SlimFAQContentsViewController.self)
        viewModel.delegate = targetViewController
        targetViewController.viewModel = viewModel
        
        let nc = UINavigationController(rootViewController: targetViewController)
        nc.setNavigationBarHidden(true, animated: false)
        nc.modalPresentationStyle = .overCurrentContext
        
        nc.view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        nc.view.isOpaque = false
        
        sourceViewController.present(nc, animated: animated, completion: completion)
        
        return targetViewController
    }
    
    @discardableResult
    static func present(from sourceViewController: UIViewController, categoryName: String, questions: [QuestionMeta], animated: Bool, completion: (()->Void)?) -> SlimFAQContentsViewController {
        
        let targetViewController = UIStoryboard(storyboard: .Contents).instantiate(viewControllerType: SlimFAQContentsViewController.self)
        
        let viewModel = SlimFAQContentsViewModel(mode: .questions(categoryName: categoryName, questions: questions))
        viewModel.delegate = targetViewController
        
        targetViewController.viewModel = viewModel
        
        if let nc = sourceViewController.navigationController {
            nc.pushViewController(targetViewController, animated: animated)
            completion?()
        } else {
            sourceViewController.present(targetViewController, animated: animated, completion: completion)
        }
        
        return targetViewController
    }
    
    @discardableResult
    static func present(from sourceViewController: UIViewController, questionMeta: QuestionMeta, animated: Bool, completion: (()->Void)?) -> SlimFAQContentsViewController {
        
        let targetViewController = UIStoryboard(storyboard: .Contents).instantiate(viewControllerType: SlimFAQContentsViewController.self)
        
        let viewModel = SlimFAQContentsViewModel(mode: .question(questionMeta))
        viewModel.delegate = targetViewController
        
        targetViewController.viewModel = viewModel
        
        if let nc = sourceViewController.navigationController {
            nc.pushViewController(targetViewController, animated: animated)
            completion?()
        } else {
            sourceViewController.present(targetViewController, animated: animated, completion: completion)
        }
        
        return targetViewController
    }
    
}
