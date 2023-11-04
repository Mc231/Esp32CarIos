//
//  CarControllable.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

protocol CarControllable {
    func setMotor(setMotorRequest: SetMotorRequest) async throws
    func setPWM(setPwmRequest: SetPwmRequest) async throws
    func fetchStatus() async throws -> CarStatus
}
