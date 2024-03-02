//
//  SetPwmRequest.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

struct SetPwmRequest: Codable {
    let pwm: String
    let motor: RoverMotor
}
