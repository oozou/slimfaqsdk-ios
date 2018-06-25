//
//  Question.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

public struct Question: Codable, JSONPathExtensionAddable {
    public let id: Int
    public let name: String
    public let content: String
    public let updatedAt: Date
    public let url: URL
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case content
        case updatedAt = "updated_at"
        case url
    }
    
}

extension Question {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        content = try container.decode(String.self, forKey: .content)
        url = try container.decode(URL.self, forKey: .url)

        let dateString = try container.decode(String.self, forKey: .updatedAt)
        let formatter: DateFormatter = .iso8601Full
        if let date = formatter.date(from: dateString) {
            updatedAt = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.updatedAt, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

extension DateFormatter {
    class var iso8601Full: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
}
