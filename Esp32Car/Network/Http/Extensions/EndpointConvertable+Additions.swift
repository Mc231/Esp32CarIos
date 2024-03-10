//
//  EndpointConvertable+Additions.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

extension EndpointConvertible {
    var requestBodyEncodingStrategy: JSONEncoder.KeyEncodingStrategy { .useDefaultKeys }
    var responsBodyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { .useDefaultKeys }
}
