//
//  RoverControlEndpoint.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

enum RoverControlEndpoint {
    case setMotor(SetMotorRequest)
    case setPWM(SetPwmRequest)
    case fetchStatus
}

// MARK: - EndpointConvertible

extension RoverControlEndpoint: EndpointConvertible {
    
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
