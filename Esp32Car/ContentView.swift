//
//  ContentView.swift
//  Esp32Car
//
//  Created by Volodymyr Shyrochuk on 25.10.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject 
    private var viewModel = CarViewModel()

    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                WebViewRepresentable().edgesIgnoringSafeArea(.all)
                // Your WebView here
                
                VStack(alignment: .leading) {
                            if let status = viewModel.carStatus {
                                Spacer()
                                Text("Status").foregroundColor(.black).fontWeight(.bold).padding(.leading, 8.0)
                                HStack {
                                    Text(status.motorsStatus)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("Distance: \(Int(status.ultrasonic.lastDistance)) (cm)")
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("Up time: \(status.system.upTime) (s)")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    
            }
            
            VStack(spacing: 16) {
                MotorControlButton(title: "Up",
                                   onPressed: viewModel.moveForward,
                                   onReleased: viewModel.stop)
                             }
                
                HStack(spacing: 16) {
                    MotorControlButton(title: "Left",
                                       onPressed: viewModel.moveLeft,
                                       onReleased: viewModel.stop)
                    MotorControlButton(title: "Right",
                                       onPressed: viewModel.moveRight,
                                       onReleased: viewModel.stop)
                }
                
                MotorControlButton(title: "Down",
                               onPressed: viewModel.moveBackward,
                               onReleased: viewModel.stop)
            
            
            Slider(value: $viewModel.speed, in: 0...255, step: 1) { isEditing in
                if !isEditing { // Executes once the user has stopped adjusting the slider.
                    viewModel.setSpeed(value: viewModel.speed)
                }
            }
            .padding(.top, 16)
           
            Text("PWM Value: \(Int(viewModel.speed))")
   
                       .padding(.top, 16)
        }
        .padding() // This will apply system padding around the VStack.
    }
}

struct MotorControlButton: View {
    let title: String
    let onPressed: () -> Void
    let onReleased: () -> Void

    var body: some View {
        Text(title)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    onPressed()
                }
                .onEnded { _ in
                    onReleased()
                }
        )
    }
}



#Preview {
    ContentView()
}
