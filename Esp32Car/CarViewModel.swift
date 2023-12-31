//
//  CarViewModel.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 25.10.2023.
//

import Foundation

@MainActor
class CarViewModel: ObservableObject {
    
    @Published var carStatus: CarStatus?
    @Published var speed: Double
    
    private let carControllable: CarControllable
    
    private var currentTask: Task<Void, Never>? = nil
    private var pwmTask: Task<Void, Never>? = nil
    private var fetchTask: Task<Void, Never>? = nil
    
    init(speed: Double,
         carControllable: CarControllable) {
        self.speed = speed
        self.carControllable = carControllable
        handleStatus()
    }
    
    convenience init(speed: Double = 127.5,
                     baseUrlProvider: BaseUrlProvider = .default,
                     requestBuilder: RequestBuilder = DefaultRequestBuilder(),
                     urlSession: URLSession = .shared) {
        let httpManager = UrlSessionHttpmManager(
            baseUrlProvider: baseUrlProvider,
            requestBuilder: requestBuilder,
            urlSession: urlSession)
        let carController = CarController(httpManager: httpManager)
        self.init(speed: speed, carControllable: carController)
    }
    
    private func handleStatus() {
       // fetchTask?.cancel()
        fetchTask = Task {
            repeat {
                do {
                    carStatus = try await carControllable.fetchStatus()
                    try await Task.sleep(for: .seconds(1))
                } catch {
                    print(error)
                }
            } while (!Task.isCancelled)
        }
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
    
    func updateStatus() {
          Task {
              do {
                  let status = try await carControllable.fetchStatus()
                  carStatus = status
                  print("Updated status:", status)
              } catch {
                  print("Failed to fetch status:", error)
              }
          }
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
        //currentTask?.cancel()
        currentTask = Task {
            do {
                try await carControllable.setMotor(setMotorRequest: request)
            } catch {
                print(error)
            }
        }
    }
}
