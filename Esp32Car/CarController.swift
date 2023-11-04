//
//  CarController.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

class CarController: CarControllable {
    
    private let httpManager: HttpManager
    
    init(httpManager: HttpManager) {
        self.httpManager = httpManager
    }
    
    func setMotor(setMotorRequest: SetMotorRequest) async throws  {
        try await httpManager.performVoideRequest(to: CarControlEndpoint.setMotor(setMotorRequest))
    }
    
    func setPWM(setPwmRequest: SetPwmRequest) async throws {
        try await httpManager.performVoideRequest(to: CarControlEndpoint.setPWM(setPwmRequest))
    }
    
    func fetchStatus() async throws -> CarStatus {
        return try await httpManager.performRequest(to: CarControlEndpoint.fetchStatus)
    }
}

protocol HttpManager {
    func performRequest(to endpoint: EndpointConvertible) async throws -> (Data, URLResponse)
}

class UrlSessionHttpmManager: HttpManager {
    
    private var baseUrlProvider: BaseUrlProvider
    private let requestBuilder: RequestBuilder
    private let urlSession: URLSession
    
    private var baseUrl: String = ""
    
    init(baseUrlProvider: BaseUrlProvider, requestBuilder: RequestBuilder, urlSession: URLSession) {
        self.baseUrlProvider = baseUrlProvider
        self.requestBuilder = requestBuilder
        self.urlSession = urlSession
        self.baseUrl = baseUrlProvider.provide(baseUrl: .api)?.absoluteString ?? ""
    }
    
    func performRequest(to endpoint: EndpointConvertible) async throws -> (Data, URLResponse) {
        let urlRequest = try requestBuilder.buildRequest(from: endpoint, baseUrl: baseUrl)
        return try await urlSession.data(for: urlRequest)
    }
}

protocol RequestBuilder {
    func buildRequest(from endpoint: EndpointConvertible, baseUrl: String?) throws -> URLRequest
}

enum RequestBuilderError: Error {
    case noBaseUrl
    case invalidUrl
}

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

extension HttpManager {
    
    func performVoideRequest(to endpoint: EndpointConvertible) async throws {
        _ = try await performRequest(to: endpoint)
    }
    
    func performRequest<T: Decodable>(to endpoint: EndpointConvertible) async throws -> T {
        let result = try await performRequest(to: endpoint)
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = endpoint.responsBodyDecodingStrategy
        return try jsonDecoder.decode(T.self, from: result.0)
    }
}

enum CarControlEndpoint {
    case setMotor(SetMotorRequest)
    case setPWM(SetPwmRequest)
    case fetchStatus
}

// MARK: - EndpointConvertible

extension CarControlEndpoint: EndpointConvertible {
    
    var httpMethod: HttpMethod {
        switch self {
        case .setMotor, .setPWM:
            return .put
        case .fetchStatus:
            return .get
        }
    }
    
    var path: RequestPath {
        switch self {
        case .setMotor:
            .partOfPath("/motor")
        case .setPWM:
            .partOfPath("/motorPWM")
        case .fetchStatus:
            .partOfPath("/status")
        }
    }
    
    var body: Encodable? {
        switch self {
        case let .setMotor(setMotorRequest):
            return setMotorRequest
        case let .setPWM(setPwmRequest):
            return setPwmRequest
        case .fetchStatus:
            return nil
        }
    }
    
    var headers: [HttpHeader : HttpHeaderValue] {
        return [.contentType: .applicationJson]
    }
    
    var responsBodyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }
}

enum HttpHeader: String {
    case contentType = "Content-Type"
}

enum HttpHeaderValue: String {
    case applicationJson = "application/json"
}

enum HttpMethod: String {
    case get
    case post
    case put
}

enum RequestPath {
    case fullPath(String)
    case partOfPath(String)
}

enum HttpBody {
    case empty
    case dictionary([String: Any])
    case encodable(Encodable, JSONEncoder.KeyEncodingStrategy)
}

protocol EndpointConvertible {
    var httpMethod: HttpMethod { get }
    var path: RequestPath { get }
    var body: Encodable? { get }
    var headers: [HttpHeader: HttpHeaderValue] { get }
    var requestBodyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
    var responsBodyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}

extension EndpointConvertible {
    var requestBodyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { .useDefaultKeys }
    var responsBodyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .useDefaultKeys }
}
