import SwiftUI
import UIKit

struct TimerView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    @State private var isStartPressed = false
    @State private var isResetPressed = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Cercle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 15)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .trim(from: 0, to: timerVM.progress)
                    .stroke(
                        Color.blue,
                        style: StrokeStyle(lineWidth: 15, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: 250, height: 250)
                    .animation(.easeInOut(duration: 0.3), value: timerVM.progress)
                
                VStack(spacing: 8) {
                    Text(timerVM.formatTime(timerVM.remainingTime))
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundColor(.primary)
                    
                    if timerVM.numberOfTimers > 1 {
                        Text("\(timerVM.currentRepetition)/\(timerVM.numberOfTimers)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .transition(.opacity)
                    }
                }
            }
            
            // Slider pour choisir le temps
            VStack {
                Slider(
                    value: Binding(
                        get: { timerVM.totalTime },
                        set: { newValue in
                            let steppedValue = round(newValue / 15) * 15
                            timerVM.totalTime = steppedValue
                            if timerVM.timerState != .running {
                                timerVM.remainingTime = steppedValue
                            }
                        }
                    ),
                    in: 15...1800,
                ) {
                    Text("Duration")
                }
                .disabled(timerVM.timerState == .running)
                
                Text("Duration: \(timerVM.formatTime(timerVM.totalTime))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            // Picker du nombre de timers
            Picker("Number of timers", selection: $timerVM.numberOfTimers) {
                ForEach(1..<6) { i in
                    Text("\(i)").tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .disabled(timerVM.timerState == .running)
            
            // Boutons avec animation
            HStack(spacing: 16) {
                Button(action: {
                    haptic(.heavy)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { isStartPressed = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { isStartPressed = false }
                    }
                    timerVM.timerState == .running ? timerVM.stop() : timerVM.start()
                }) {
                    Text(timerVM.timerState == .running ? "Pause" : "Start")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(timerVM.timerState == .running ? .orange : .blue)
                .scaleEffect(isStartPressed ? 0.92 : 1.0)
                
                Button(action: {
                    haptic(.medium)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { isResetPressed = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { isResetPressed = false }
                    }
                    timerVM.reset()
                }) {
                    Text("Reset")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
                .disabled(timerVM.remainingTime == timerVM.totalTime)
                .opacity(timerVM.remainingTime == timerVM.totalTime ? 0.5 : 1)
                .scaleEffect(isResetPressed ? 0.92 : 1.0)
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
    }
    
    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerViewModel())
}

