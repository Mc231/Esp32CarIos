//
//  Device.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

struct Device: DeviceRepresentable {
    let id: String
    let name: String
    let ipAddress: String
    let deviceType: DeviceType
}
