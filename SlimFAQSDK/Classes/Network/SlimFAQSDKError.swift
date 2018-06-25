//
//  SlimFAQSDKError.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw SlimFAQSDKError.invalidURL(url: self) }
        return url
    }
}

internal enum SlimFAQSDKError: Error {
    case missingClientId
    case invalidURL(url: URLConvertible)
    case jsonEncodingFailed(error: Error)
    case statusCode(Int)
    case noData
    
    private enum Constants {
        static let domain = "com.oozou.SlimFAQSDKError"
    }
}

extension SlimFAQSDKError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .missingClientId:
            return NSLocalizedString("missing client id", comment: "")
        case .invalidURL(let url):
            return "URL is not valid: \(url)"
        case .jsonEncodingFailed(let error):
            return "JSON could not be encoded because of error:\n\(error.localizedDescription)"
        case .statusCode(let code):
            return "status code: \(code)"
        case .noData:
            return "No data at the response"
        }
    }
    
    public var error: Error {
        let errorString = errorDescription ?? ""
        return NSError(domain: SlimFAQSDKError.Constants.domain, code: 0, userInfo: [NSLocalizedDescriptionKey: errorString])
    }
}
