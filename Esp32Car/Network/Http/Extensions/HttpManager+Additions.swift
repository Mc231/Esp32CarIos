//
//  HttpManager+Additions.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

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
