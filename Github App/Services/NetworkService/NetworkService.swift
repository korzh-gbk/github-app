//
//  NetworkService.swift
//  Github App
//
//  Created by Artem Korzh on 26.01.2022.
//

import Foundation
import Combine

final class NetworkService {
    let session: URLSession

    lazy var decoder: JSONDecoder = {
        var decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    enum NetworkError: Error {
        case serverError(statusCode: Int?)
        case noDataReceived
        case decodingFailed(DecodingError)
        case unknown(Error)
    }

    init(session: URLSession = .shared) {
        self.session = session
    }

    func make<Model: Decodable>(request: NetworkRequest) -> AnyPublisher<Model, Error> {
        var urlRequest = URLRequest(url: request.requestURL)
        urlRequest.httpMethod = request.method.rawValue
        request.headers.forEach({ urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) })
        urlRequest.httpBody = request.body?.encoded
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                guard let code = statusCode,
                      (200..<300) ~= code else {
                          throw NetworkError.serverError(statusCode: statusCode)
                      }
                return data
            }
            .decode(type: Model.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
