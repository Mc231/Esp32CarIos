//
//  ConfigProvider.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 04.11.2023.
//

import Foundation

final class ConfigProvider {
    
    static let `default` = ConfigProvider(.main)
    
    private let bundle: Bundle
    
    init(_ bundle: Bundle) {
        self.bundle = bundle
    }
    
    func getConfigValue(for key: ConfigKey) -> String? {
        bundle.infoDictionary?[key.rawValue.uppercased()] as? String
    }
}

extension ConfigProvider {
    enum ConfigKey: String {
        case carHost
    }
}
