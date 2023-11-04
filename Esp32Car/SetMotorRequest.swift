//
//  SetMotorRequest.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

struct SetMotorRequest: Codable {
    let action: CarMotorAction
    let motor: CarMotor
}
