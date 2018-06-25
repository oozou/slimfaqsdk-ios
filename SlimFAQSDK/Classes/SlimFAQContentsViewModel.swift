//
//  SlimFAQContentsViewModel.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

enum SlimFAQContentsScreenMode {
    case contents(clientId: String)
    case questions(categoryName: String, questions: [QuestionMeta])
    case question(QuestionMeta)
}

internal enum SlimFAQContentsScreenItem {
    case category(CategoryItemViewModel)
    case question(QuestionItemViewModel)
    case loading(LoadingStateViewModel)
    case empty(EmptyStateViewModel)
    case questionDetails(QuestionDetailsViewModel)
}

internal protocol SlimFAQContentsViewModelDataSource {
    var screenMode: SlimFAQContentsScreenMode { get }
    var screenTitle: String { get }
    var canRefreshData: Bool { get }
    var numberOfSections: Int { get }
    func numberOfItems(in section: Int) -> Int
    func item(for indexPath: IndexPath) -> SlimFAQContentsScreenItem
}

internal protocol SlimFAQContentsViewModelActions {
    func viewDidLoad()
    func viewWillAppear()
    func didTouchRefreshButton()
}

internal protocol SlimFAQContentsViewModelDelegate {
    func slimFAQViewModelSetNeedsReload(viewModel: SlimFAQContentsViewModelType)
    func slimFAQViewModelDidReceiveAnError(viewModel: SlimFAQContentsViewModelType, errorMessage: String)
    func slimFAQViewModelSetBusy(busy: Bool, viewModel: SlimFAQContentsViewModelType)
}

internal protocol SlimFAQContentsViewModelType {
    var dataSource: SlimFAQContentsViewModelDataSource { get }
    var actions: SlimFAQContentsViewModelActions { get }
    var delegate: SlimFAQContentsViewModelDelegate? { get set }
}

internal final class SlimFAQContentsViewModel: SlimFAQContentsViewModelType, SlimFAQContentsViewModelDataSource, SlimFAQContentsViewModelActions {
    
    var dataSource: SlimFAQContentsViewModelDataSource { return self }
    var actions: SlimFAQContentsViewModelActions { return self }
    var delegate: SlimFAQContentsViewModelDelegate?
    
    private var categoriesList: CategoriesList?
    private var question: Question?
    
    private var dataSourceItems: [[SlimFAQContentsScreenItem]] = []
    private var loadAttemptsCount: Int = 0
    private var isLoading: Bool = false
    let screenMode: SlimFAQContentsScreenMode
    
    internal init(mode: SlimFAQContentsScreenMode) {
        self.screenMode = mode
    }
    
    // MARK: DataSource
    
    private func updateDataSource() {
        switch screenMode {
        case .contents:
            updateDataSourceForCategories()
        case .questions:
            updateDataSourceForQuestions()
        case .question:
            updateDataSourceForQuestion()
        }
    }
    
    private func updateDataSourceForCategories() {
        var newDataSourceItems: [[SlimFAQContentsScreenItem]] = []
        
        /*** Loading State ***/
        let loadingState = loadingItemAttributes()
        if let vm = loadingState.viewModel, loadingState.canPresent {
            newDataSourceItems += [[.loading(vm)]]
        }
        
        /*** Categories ***/
        let categoriesAttributes = categoryListAttributes()
        if categoriesAttributes.canPresent {
            for item in categoriesAttributes.categories {
                let vm = CategoryItemViewModel(category: item)
                newDataSourceItems += [[.category(vm)]]
            }
        }
    
        /*** Empty State ***/
        let emptyState = emptyItemAttributes()
        if let vm = emptyState.viewModel, emptyState.canPresent {
            newDataSourceItems += [[.empty(vm)]]
        }
        
        self.dataSourceItems = newDataSourceItems
    }
    
    private func updateDataSourceForQuestions() {
        var newDataSourceItems: [[SlimFAQContentsScreenItem]] = []
        
        /*** Loading State ***/
        let loadingState = loadingItemAttributes()
        if let vm = loadingState.viewModel, loadingState.canPresent {
            newDataSourceItems += [[.loading(vm)]]
        }
        
        /*** Questions ***/
        let _questionsAttributes = questionsAttributes()
        if _questionsAttributes.canPresent {
            for item in _questionsAttributes.questions {
                let vm = QuestionItemViewModel(question: item)
                newDataSourceItems += [[.question(vm)]]
            }
        }
        
        /*** Empty State ***/
        let emptyState = emptyItemAttributes()
        if let vm = emptyState.viewModel, emptyState.canPresent {
            newDataSourceItems += [[.empty(vm)]]
        }
        
        self.dataSourceItems = newDataSourceItems
    }
    
    private func updateDataSourceForQuestion() {
        var newDataSourceItems: [[SlimFAQContentsScreenItem]] = []
        
        /*** Loading State ***/
        let loadingState = loadingItemAttributes()
        if let vm = loadingState.viewModel, loadingState.canPresent {
            newDataSourceItems += [[.loading(vm)]]
        }
        
        /*** Question ***/
        let _questionAttributes = questionAttributes()
        if let question = _questionAttributes.question, _questionAttributes.canPresent {
            let vm = QuestionDetailsViewModel(question: question)
            newDataSourceItems += [[.questionDetails(vm)]]
        }
        
        /*** Empty State ***/
        let emptyState = emptyItemAttributes()
        if let vm = emptyState.viewModel, emptyState.canPresent {
            newDataSourceItems += [[.empty(vm)]]
        }
        
        self.dataSourceItems = newDataSourceItems
    }
    
    var screenTitle: String {
        switch screenMode {
        case .contents:
            return categoriesList?.name ?? ""
        case .questions(let categoryName, _):
            return categoryName
        case .question(let meta):
            return question?.name ?? meta.name
        }
    }
    
    var canRefreshData: Bool {
        switch screenMode {
        case .contents, .question:
            return true
        case .questions:
            return false
        }
    }
    
    internal var numberOfSections: Int {
        return dataSourceItems.count
    }
    
    internal func numberOfItems(in section: Int) -> Int {
        return dataSourceItems[section].count
    }
    
    internal func item(for indexPath: IndexPath) -> SlimFAQContentsScreenItem {
        return dataSourceItems[indexPath.section][indexPath.row]
    }
    
    // MARK: Actions
    func viewDidLoad() {}
    
    func viewWillAppear() {
        loadData()
    }
    
    func didTouchRefreshButton() {
        switch screenMode {
        case .contents(let clientId):
            loadCategories(clientId)
        case .questions:
            break
        case .question(let meta):
            loadQuestionData(from: meta)
        }
    }
    
    private func loadingItemAttributes() -> (canPresent: Bool, viewModel: LoadingStateViewModel?) {
        if isLoading {
            let viewModel = LoadingStateViewModel(title: "Loading...")
            return (true, viewModel)
        } else {
            return (false, nil)
        }
    }
    
    private func categoryListAttributes() -> (canPresent: Bool, categories: [Category]) {
        let canPresent: Bool
    
        switch screenMode {
        case .contents:
            let categoriesLoadedCount = categoriesList?.categories.count ?? 0
            canPresent = categoriesLoadedCount > 0 && !isLoading
        case .questions, .question:
            canPresent = false
        }
        
        if !canPresent {
            return (false, [])
        } else {
            guard let categories = categoriesList?.categories, categories.count > 0 else { return (false, []) }
            return (true, categories)
        }
    }
    
    private func emptyItemAttributes() -> (canPresent: Bool, viewModel: EmptyStateViewModel?) {
        
        let hasData: Bool
        switch screenMode {
        case .contents:
            hasData = (categoriesList?.categories.count ?? 0) > 0
        case .questions(_, let questions):
            hasData = questions.count != 0
        case .question:
            hasData = question != nil
        }
        
        let canPresent = !isLoading && loadAttemptsCount > 0 && !hasData
        
        if !canPresent {
            return (false, nil)
        } else {
            let viewModel = EmptyStateViewModel(title: "Unable to load data.", image: nil)
            return (true, viewModel)
        }
    }
    
    private func questionsAttributes() -> (canPresent: Bool, questions: [QuestionMeta]) {
        let canPresent: Bool
        let questions: [QuestionMeta]
        
        switch screenMode {
        case .contents, .question:
            canPresent = false
            questions = []
        case .questions(_, let _questions):
            canPresent = _questions.count > 0
            questions = _questions
        }
        
        if !canPresent {
            return (false, [])
        } else {
            return (true, questions)
        }
    }
    
    private func questionAttributes() -> (canPresent: Bool, question: Question?) {
        switch screenMode {
        case .contents, .questions:
            return (false, nil)
        case .question:
            if let question = self.question {
                return (true, question)
            } else {
                return (false, nil)
            }
        }
    }
    
}

extension SlimFAQContentsViewModel {
    
    private func loadData() {
        switch screenMode {
        case .contents(let clientId):
            if let list = categoriesList {
                updateDataSource(with: list)
            } else {
                loadCategories(clientId)
            }
        case .questions(let categoryName, let questions):
            updateDataSource(with: categoryName, questions: questions)
        case .question(let meta):
            loadQuestionData(from: meta)
        }
    }
    
    private func loadCategories(_ clientId: String) {
        
        let busy: ((Bool) -> Void) = { [weak self] busy in
            guard let weakSelf = self else { return }
            weakSelf.isLoading = busy
            weakSelf.updateDataSource()
            weakSelf.delegate?.slimFAQViewModelSetBusy(busy: busy, viewModel: weakSelf)
            weakSelf.delegate?.slimFAQViewModelSetNeedsReload(viewModel: weakSelf)
        }
        
        busy(true)
        loadAttemptsCount += 1
        
        APIManager.shared.request(.categoriesList(clientId: clientId)) { [weak self] (result: Result<CategoriesList>) in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let categoriesList):
                weakSelf.categoriesList = categoriesList
            case .error(let error):
                weakSelf.delegate?.slimFAQViewModelDidReceiveAnError(viewModel: weakSelf, errorMessage: error.localizedDescription)
            }
            
            busy(false)
        }
    }
    
    private func loadQuestionData(from meta: QuestionMeta) {
        let busy: ((Bool) -> Void) = { [weak self] busy in
            guard let weakSelf = self else { return }
            weakSelf.isLoading = busy
            weakSelf.updateDataSource()
            weakSelf.delegate?.slimFAQViewModelSetBusy(busy: busy, viewModel: weakSelf)
            weakSelf.delegate?.slimFAQViewModelSetNeedsReload(viewModel: weakSelf)
        }
        
        busy(true)
        loadAttemptsCount += 1
        
        APIManager.shared.request(.question(questionURL: meta.jsonURL), completion: ({ [weak self] (result: Result<Question>) in
            guard let weakSelf = self else { return }
            
            switch result {
            case .success(let question):
                weakSelf.question = question
            case .error(let error):
                weakSelf.delegate?.slimFAQViewModelDidReceiveAnError(viewModel: weakSelf, errorMessage: error.localizedDescription)
            }
            
            busy(false)
        }))
    }
    
    private func updateDataSource(with categories: CategoriesList) {
        updateDataSource()
        delegate?.slimFAQViewModelSetNeedsReload(viewModel: self)
    }
    
    private func updateDataSource(with categoryName: String, questions: [QuestionMeta]) {
        updateDataSource()
        delegate?.slimFAQViewModelSetNeedsReload(viewModel: self)
    }
    
}
