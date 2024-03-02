//
//  RoverMotorAction.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 29.10.2023.
//

import Foundation

enum RoverMotorAction: Int, Codable {
    case forward = 0
    case bckward = 1
    case stop = 2
    
    var shortDescription: String {
        switch self {
        case .forward:
            return "F"
        case .bckward:
            return "B"
        case .stop:
            return "S"
        }
    }
}
