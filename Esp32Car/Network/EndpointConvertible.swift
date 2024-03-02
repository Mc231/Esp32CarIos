//
//  EndpointConvertible.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

protocol EndpointConvertible {
    var httpMethod: HttpMethod { get }
    var path: RequestPath { get }
    var body: Encodable? { get }
    var headers: [HttpHeader: HttpHeaderValue] { get }
    var requestBodyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { get }
    var responsBodyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}
