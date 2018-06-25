//
//  QuestionDetailsViewModel.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/21/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

internal struct QuestionDetailsViewModel {
    let question: Question
    let name: String
    let htmlContent: String
    let updatedText: String
    
    init(question: Question) {
        self.question = question
        self.name = question.name
        self.htmlContent = QuestionDetailsViewModel.htmlStringByAddingStyle(question.content)
        self.updatedText = "Last update: \(question.updatedAt.timeAgo())"
    }
    
    private static func htmlStringByAddingStyle(_ input: String) -> String {
        let of = "<div>"
        let with = """
<div style="font-size:44px;>"
"""
        let output = input.replacingOccurrences(of: of, with: with)
        return output
    }
    
}
