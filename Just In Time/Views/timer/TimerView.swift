import SwiftUI
import Combine
import UIKit

struct TimerView: View {
    @StateObject private var viewModel = TimerViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                // Cercle de fond
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.2)
                    .foregroundColor(.gray)
                
                // Cercle qui se retracte
                Circle()
                    .trim(from: 0.0, to: viewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.05), value: viewModel.progress)
                
                // Temps restant au centre
                Text(formatTime(viewModel.remainingTime))
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
            .frame(width: 250, height: 250)
            
            // Slider de durée
            VStack {
                Text("Définir la durée : \(formatTime(viewModel.totalTime))")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Slider(value: $viewModel.totalTime, in: 1...3600) {
                    Text("Durée du minuteur")
                } minimumValueLabel: {
                    Text("0:01").foregroundColor(.white)
                } maximumValueLabel: {
                    Text("60:00").foregroundColor(.white)
                }
                .tint(.blue)
                .padding(.horizontal)
                .disabled(viewModel.timerState == .running)
            }
            .padding(.horizontal)
            
            // Boutons de contrôle
            HStack(spacing: 30) {
                // Start / Pause
                Button(action: {
                    hapticFeedback(.heavy)
                    
                    if viewModel.timerState == .running {
                        viewModel.stop()
                    } else {
                        viewModel.start()
                    }
                }) {
                    Text(viewModel.timerState == .running ? "Pause" : "Start")
                        .fontWeight(.bold)
                        .frame(width: 120, height: 50) // 👈 même taille
                        .background(viewModel.timerState == .running ? Color.orange : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                
                // Reset
                Button(action: {
                    hapticFeedback(.medium)
                    viewModel.reset()
                }) {
                    Text("Reset")
                        .fontWeight(.bold)
                        .frame(width: 120, height: 50) // 👈 même taille
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                .disabled(viewModel.timerState == .stopped && viewModel.remainingTime == viewModel.totalTime)
                .opacity(viewModel.timerState == .stopped && viewModel.remainingTime == viewModel.totalTime ? 0.5 : 1)
            }
        }
        .padding()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

#Preview {
    TimerView()
}

