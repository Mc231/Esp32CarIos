//
//  RoverControllable.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

protocol RoverControllable {
    var onStatusUpdated: (RoverStatus) -> Swift.Void { get set}
    func setMotor(setMotorRequest: SetMotorRequest) async throws
    func setPWM(setPwmRequest: SetPwmRequest) async throws
    func startObservingStatusUpdate()
    func stopObservingStatusUpdate()
}
