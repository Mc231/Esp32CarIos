//
//  DefaultRequestBuilder.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

final class DefaultRequestBuilder: RequestBuilder {
    func buildRequest(from endpoint: EndpointConvertible, baseUrl: String?) throws -> URLRequest {
        var urlPath:  String
        switch endpoint.path {
            case let .fullPath(fullPath):
                urlPath = fullPath
            case let .partOfPath(path):
                if let baseUrl {
                    urlPath = "\(baseUrl)\(path)"
                } else {
                    throw RequestBuilderError.noBaseUrl
                }
        }
        
        let url = URL(string: urlPath)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.httpMethod.rawValue
        endpoint.headers.forEach { entry in
            urlRequest.setValue(entry.value.rawValue, forHTTPHeaderField: entry.key.rawValue)
        }
        if let body = endpoint.body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = endpoint.requestBodyEncodingStrategy
            urlRequest.httpBody = try encoder.encode(body)
        }
        return urlRequest
    }
}
