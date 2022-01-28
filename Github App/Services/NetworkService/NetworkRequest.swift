//
//  NetworkRequest.swift
//  Github App
//
//  Created by Artem Korzh on 26.01.2022.
//

import Foundation


struct NetworkRequest {

    public enum RequestMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
        case put = "PUT"
        case patch = "PATCH"
    }

    let endpoint: URL
    var method: RequestMethod = .get
    var query: [String: Any] = [:]
    var headers: [String: String] = [:]
    var body: Encodable? = nil

    var requestURL: URL {
        var path = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)!
        if query.count > 0 {
            var queryItems: [URLQueryItem] = []
            query.forEach { (key, value) in
                if let array = value as? [Any] {
                    queryItems.append(contentsOf: array.map({URLQueryItem(name: "\(key)[]", value: "\($0)")}))
                    return
                }
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            path.queryItems = queryItems
        }
        return path.url!
    }
}
