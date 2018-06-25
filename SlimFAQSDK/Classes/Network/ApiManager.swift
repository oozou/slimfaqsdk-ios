//
//  ApiManager.swift
//  SlimFAQ-SDK
//
//  Created by Stan Baranouski on 6/20/18.
//  Copyright © 2018 Oozou Limited. All rights reserved.
//

import Foundation

public enum Result<T> {
    case success(T)
    case error(Error)
}

internal final class APIManager {
    
    internal static let shared = APIManager()
    private init() {}
    
    private func response(for route: NetworkAPIRouter, completion: @escaping(Result<Data>)->()) {
        do {
            let request = try route.asURLRequest()
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    completion(.error(error))
                } else {
                    let httpResponse = response as! HTTPURLResponse
                    /// referring to https://gist.github.com/ollieatkinson/322338df8a5220d649ac01ff11e7de12
                    switch httpResponse.statusCode {
                    case 200...299:
                        if let data = data {
                            completion(.success(data))
                        } else {
                            completion(.error(SlimFAQSDKError.noData.error))
                        }
                    default:
                        completion(.error(SlimFAQSDKError.statusCode(httpResponse.statusCode)))
                        
                    }
                }
            }).resume()
        } catch {
            completion(.error(error))
        }
    }
    
    internal func request<T: Decodable>(_ route: NetworkAPIRouter, completion: @escaping (Result<T>) -> ()) {
        response(for: route) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                    let decodedResult = try decoder.decode(T.self, from: data)
                    completion(.success(decodedResult))
                } catch {
                    completion(.error(error))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
}

internal enum NetworkAPIRouter {
    
    private enum Constants {
        static let baseUrl = "https://slimfaq.com"
        static let jsonPath = ".json"
    }
    
    case categoriesList(clientId: String)
    case question(questionURL: URL)
    
    private var method: HTTPMethod {
        switch self {
        case .categoriesList, .question:
            return .get
        }
    }
    
    private var request: (path: String, parameters: Parameters?) {
        switch self {
        case .categoriesList(let clientId):
            let params: [String: Any] = ["include" : "categories.questions"]
            return ("/\(clientId)\(NetworkAPIRouter.Constants.jsonPath)", params)
        case .question(let url):
            return (url.path, nil)
        }
    }
    
    internal func asURLRequest() throws -> URLRequest {
        let url = try NetworkAPIRouter.Constants.baseUrl.asURL()
        
        let params = request.parameters
        let path = request.path
        
        var urlRequest: URLRequest
        if let parameters = stringFromHttpParameters(params) {
            urlRequest = URLRequest(url: URL(string: "\(url.absoluteString)\(path)?\(parameters)")!)
        } else {
            urlRequest = URLRequest(url: url.appendingPathComponent(path))
        }
        
        urlRequest.httpMethod = method.rawValue
        
        let headers: HTTPHeaders = [
            "platform": "ios",
            "language": NSLocale.current.languageCode ?? "en",
            "sdk-version": Bundle.sdkVersion
        ]
        
        urlRequest.allHTTPHeaderFields = headers

        return urlRequest
    }
    
    func stringFromHttpParameters(_ dict: [String : Any]?) -> String? {
        guard let dict = dict else { return nil }
        
        let parameterArray = dict.map { (key, value) -> String in
            let percentEscapedKey = key.stringByAddingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).stringByAddingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }
        
        return parameterArray.joined(separator: "&")
    }
    
}

extension String {
    func stringByAddingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
}
