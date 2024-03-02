//
//  RoverStatus.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

struct RoverStatus: Codable {
    struct System: Codable {
            let upTime: Int
        }
        struct Ultrasonic: Codable {
            let lastDistance: Double
        }
        struct Motor: Codable {
            let lma: RoverMotorAction
            let rma: RoverMotorAction
            let lmpwm: Int
            let rmpwm: Int
        }

        let system: System
        let ultrasonic: Ultrasonic
        let motor: Motor
}

extension RoverStatus {
    var motorsStatus: String {
        """
          L: \(motor.lma.shortDescription) : \(motor.lmpwm)
          R: \(motor.rma.shortDescription) : \(motor.rmpwm)
        """
    }
}
