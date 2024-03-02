//
//  RequestBuilder.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

protocol RequestBuilder {
    func buildRequest(from endpoint: EndpointConvertible, baseUrl: String?) throws -> URLRequest
}
