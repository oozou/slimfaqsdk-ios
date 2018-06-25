//
//  QuestionItemViewModel.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

internal struct QuestionItemViewModel {
    let question: QuestionMeta
    let title: String
    
    init(question: QuestionMeta) {
        self.question = question
        self.title = question.name
    }
    
}
