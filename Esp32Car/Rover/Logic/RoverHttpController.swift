//
//  RoverController.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

class RoverHttpController: RoverControllable {
    
    private let httpManager: HttpManager
    
    init(httpManager: HttpManager) {
        self.httpManager = httpManager
    }
    
    func setMotor(setMotorRequest: SetMotorRequest) async throws  {
        try await httpManager.performVoideRequest(to: RoverControlEndpoint.setMotor(setMotorRequest))
    }
    
    func setPWM(setPwmRequest: SetPwmRequest) async throws {
        try await httpManager.performVoideRequest(to: RoverControlEndpoint.setPWM(setPwmRequest))
    }
    
    func fetchStatus() async throws -> RoverStatus {
        return try await httpManager.performRequest(to: RoverControlEndpoint.fetchStatus)
    }
}






