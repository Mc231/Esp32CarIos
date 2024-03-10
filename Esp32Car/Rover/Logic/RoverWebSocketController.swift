//
//  RoverWebSocketController.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 10.03.2024.
//

import Foundation

class RoverWebSocketController: RoverControllable {

    var onStatusUpdated: (RoverStatus) -> Void = { _ in }

    private let webSocketManager: WebSocketManagerProtocol
    private var fetchTask: Task<Void, Never>? = nil

    init(webSocketManager: WebSocketManagerProtocol) {
        self.webSocketManager = webSocketManager
    }

    func setMotor(setMotorRequest: SetMotorRequest) async throws {
//        let message = convertToWebSocketMessage(request: setMotorRequest)
//        webSocketManager.sendMessage(message)
    }

    func setPWM(setPwmRequest: SetPwmRequest) async throws {
//        let message = convertToWebSocketMessage(request: setPwmRequest)
//        webSocketManager.sendMessage(message)
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

private extension RoverWebSocketController {
    func fetchStatus() async throws -> RoverStatus {
        // Implement fetching status logic here.
        // This could involve sending a request for status over the WebSocket and then waiting for a response.
        fatalError("fetchStatus not implemented")
    }

    func convertToWebSocketMessage<T>(request: T) -> String {
        // Convert your request into a WebSocket message string.
        // This might involve serializing a Swift struct into a JSON string.
        fatalError("convertToWebSocketMessage not implemented")
    }
}
