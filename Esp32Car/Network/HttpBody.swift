//
//  HttpBody.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

enum HttpBody {
    case empty
    case dictionary([String: Any])
    case encodable(Encodable, JSONEncoder.KeyEncodingStrategy)
}
