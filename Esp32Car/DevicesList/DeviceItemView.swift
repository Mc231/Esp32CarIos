//
//  DeviceItemView.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 02.03.2024.
//

import Foundation
import SwiftUI

struct DeviceItemView: View {
    
    let item: any DeviceRepresentable
    
    var body: some View {
        VStackLayout(alignment: .center) {
            Text(item.name)
        }
    }
}

#Preview {
    DeviceItemView(item: Device(id: "", name: "Test", ipAddress: "", deviceType: .rover))
}
