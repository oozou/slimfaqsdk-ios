//
//  CategoryItemViewModel.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

internal struct CategoryItemViewModel {
    private let category: Category
    let title: String
    let questions: [QuestionMeta]
    
    init(category: Category, questions: [QuestionMeta]? = nil) {
        self.category = category
        self.title = category.name
        self.questions = questions ?? category.questions
    }
    
}
