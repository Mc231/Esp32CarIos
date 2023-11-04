//
//  BaseUrlProvider.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 04.11.2023.
//

import Foundation

enum BaseUrl {
    case stream
    case api
}

final class BaseUrlProvider {
    private let configProvider: ConfigProvider
    
    static let `default` = BaseUrlProvider(configProvider: .default)
    
    private var host: String? {
        return configProvider.getConfigValue(for: .carHost)
    }
    
    init(configProvider: ConfigProvider) {
        self.configProvider = configProvider
    }
    
    func provide(baseUrl: BaseUrl) -> URL? {
        if let host {
            var components = URLComponents()
            components.scheme = "http"
            components.host = host
            switch baseUrl {
            case .stream:
                components.port = 81
                components.path = "/stream"
            case .api:
                components.port = 32231
            }
            return components.url
        }
        return nil
    }
}
