//
//  SelectDeviceView.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation
import SwiftUI

struct DevicesView: View {
    
    let devices: [any DeviceRepresentable]
    
    var body: some View {
        ForEach(devices, id: \.id) { item in
            DeviceItemView(item: item).onTapGesture {
                // TODO: - Handle logic
            }
        }
    }
}

#Preview {
    DevicesView(devices: [
        Device(id: "", name: "Test", ipAddress: "", deviceType: .rover),
        Device(id: "", name: "Test2", ipAddress: "", deviceType: .rover),
        Device(id: "", name: "Test3", ipAddress: "", deviceType: .rover)])
}
