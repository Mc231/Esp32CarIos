//
//  RoverController.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

class RoverHttpController: RoverControllable {
    
    var onStatusUpdated: (RoverStatus) -> Void = { _ in }
    
    private let httpManager: HttpManager
    private var fetchTask: Task<Void, Never>? = nil
    
    init(httpManager: HttpManager) {
        self.httpManager = httpManager
    }
    
    func setMotor(setMotorRequest: SetMotorRequest) async throws  {
        try await httpManager.performVoideRequest(to: RoverControlEndpoint.setMotor(setMotorRequest))
    }
    
    func setPWM(setPwmRequest: SetPwmRequest) async throws {
        try await httpManager.performVoideRequest(to: RoverControlEndpoint.setPWM(setPwmRequest))
    }
    
    func startObservingStatusUpdate() {
        fetchTask = Task {
            repeat {
                do {
                    let status = try await fetchStatus()
                    onStatusUpdated(status)
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    print(error)
                }
            } while (!Task.isCancelled)
        }
    }
    
    func stopObservingStatusUpdate() {
        fetchTask?.cancel()
    }
}

// MARK: - Private Methods

private extension RoverHttpController {
    func fetchStatus() async throws -> RoverStatus {
        return try await httpManager.performRequest(to: RoverControlEndpoint.fetchStatus)
    }
}






