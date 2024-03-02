//
//  HttpManager.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

protocol HttpManager {
    func performRequest(to endpoint: EndpointConvertible) async throws -> (Data, URLResponse)
}
