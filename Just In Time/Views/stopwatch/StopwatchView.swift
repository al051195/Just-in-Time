import SwiftUI
import Combine
import UIKit

struct StopwatchView: View {
    @StateObject private var viewModel = StopwatchViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                // Cercle de fond
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.2)
                    .foregroundColor(.gray)
                
                // Cercle qui progresse avec le temps
                Circle()
                    .trim(from: 0.0, to: min(CGFloat(viewModel.elapsedTime / 60), 1.0)) // un tour = 60 sec
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.05), value: viewModel.elapsedTime)
                
                // Temps écoulé
                Text(viewModel.elapsedTimeString)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
            .frame(width: 250, height: 250)
            
            // Boutons de contrôle
            HStack(spacing: 30) {
                // Start / Pause
                Button(action: {
                    hapticFeedback(.heavy)
                    
                    if viewModel.isRunning {
                        viewModel.stop()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Text(viewModel.isRunning ? "Pause" : "Start")
                        .fontWeight(.bold)
                        .frame(width: 120, height: 50)
                        .background(viewModel.isRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                
                // Lap
                Button(action: {
                    hapticFeedback(.medium)
                    viewModel.lap()
                }) {
                    Text("Lap")
                        .fontWeight(.bold)
                        .frame(width: 120, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .disabled(!viewModel.isRunning)
                .opacity(viewModel.isRunning ? 1 : 0.5)
                
                // Reset
                Button(action: {
                    hapticFeedback(.medium)
                    viewModel.reset()
                }) {
                    Text("Reset")
                        .fontWeight(.bold)
                        .frame(width: 120, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .disabled(viewModel.elapsedTime == 0)
                .opacity(viewModel.elapsedTime == 0 ? 0.5 : 1)
            }
            
            // Liste des tours
            if !viewModel.laps.isEmpty {
                VStack(alignment: .leading) {
                    Text("Laps:")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    ForEach(Array(viewModel.laps.enumerated()), id: \.offset) { index, lap in
                        Text("Lap \(index + 1): \(lap)")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .padding()
    }
    
    private func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

#Preview {
    StopwatchView()
}

