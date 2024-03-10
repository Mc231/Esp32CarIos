//
//  RoverControllViewModel.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 25.10.2023.
//

import Foundation

@MainActor
class RoverControllViewModel: ObservableObject {
    
    @Published var carStatus: RoverStatus?
    @Published var speed: Double
    
    private var carControllable: RoverControllable
    
    private var currentTask: Task<Void, Never>? = nil
    private var pwmTask: Task<Void, Never>? = nil
 
    
    init(speed: Double,
         carControllable: RoverControllable) {
        self.speed = speed
        self.carControllable = carControllable
        self.carControllable.onStatusUpdated = onStatusUpdated(_:)
    }
    
    convenience init(speed: Double = 127.5,
                     baseUrlProvider: BaseUrlProvider = .default,
                     requestBuilder: RequestBuilder = DefaultRequestBuilder(),
                     urlSession: URLSession = .shared) {
        let httpManager = UrlSessionHttpManager(
            baseUrlProvider: baseUrlProvider,
            requestBuilder: requestBuilder,
            urlSession: urlSession)
        let carController = RoverHttpController(httpManager: httpManager)
        self.init(speed: speed, carControllable: carController)
    }
    
    private func onStatusUpdated(_ status: RoverStatus) {
        carStatus = status
    }
    
    // Methods for controlling the car
    func moveForward() {
        setMotor(request: .init(action: .forward, motor: .both))
    }
    
    func moveLeft() {
        setMotor(request: .init(action: .bckward, motor: .left))
    }
    
    func moveRight() {
        setMotor(request: .init(action: .bckward, motor: .right))
    }
    
    func moveBackward() {
        setMotor(request: .init(action: .bckward, motor: .both))
    }
    
    func stop() {
        setMotor(request: .init(action: .stop, motor: .both))
    }
    
    func setSpeed(value: Double) {
            pwmTask = Task {
                do {
                    try await carControllable.setPWM(setPwmRequest: .init(pwm: "\(Int(value))", motor: .both))
                } catch {
                    print(error)
                }
            }
    }
    
    private func setMotor(request: SetMotorRequest) {
        currentTask = Task {
            do {
                try await carControllable.setMotor(setMotorRequest: request)
            } catch {
                print(error)
            }
        }
    }
}
