//
//  DeviceRepresentable.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation

protocol DeviceRepresentable: Identifiable {
    var id: String { get }
    var name: String { get }
    var ipAddress: String { get }
    var deviceType: DeviceType { get }
}
