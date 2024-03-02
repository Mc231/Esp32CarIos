//
//  UrlSessionHttpmManager-.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

class UrlSessionHttpManager: HttpManager {
    
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
