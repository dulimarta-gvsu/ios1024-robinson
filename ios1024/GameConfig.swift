//
//  GameConfig.swift
//  ios1024
//
//  Created by Stephen Robinson on 12/15/24.
//
import SwiftUI

struct GameConfigurationView: View {
    @Binding var gridSize: Int
    @Binding var targetValue: Int
    @Environment(\.presentationMode) var presentationMode // To dismiss the settings screen

    var body: some View {
        VStack {
            // Title
            Text("Game Configuration")
                .font(.title)
                .padding()

            // Grid Size Slider
            VStack {
                Text("Grid Size: \(gridSize)x\(gridSize)")
                Slider(value: Binding(
                        get: { Double(gridSize) },
                        set: { gridSize = Int($0) }
                    ), in: 2...6, step: 1)
                    .padding()
            }
            
            // Target Value Slider
            VStack {
                Text("Target Value: \(targetValue)")
                Slider(value: Binding(
                        get: { Double(targetValue) },
                        set: { targetValue = Int($0) }
                    ), in: 512...2048, step: 512)
                    .padding()
            }
            
            // Save Button (optional if you want to handle saving or confirmation)
            Button("Save Settings") {
                // Handle settings save (e.g., close the screen or show a confirmation)
                presentationMode.wrappedValue.dismiss() // Close the settings screen

            }
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}

#Preview {
    GameConfigurationView(gridSize: .constant(4), targetValue: .constant(1024))
}
