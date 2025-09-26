import SwiftUI
import UIKit

struct TimerView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isStartPressed = false
    @State private var isResetPressed = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Circle Progress
            ZStack {
                Circle()
                    .stroke(lineWidth: 18)
                    .opacity(0.15)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: timerVM.progress)
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .foregroundColor(colorScheme == .dark ? .blue : .accentColor)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.05), value: timerVM.progress)
                
                Text(timerVM.formatTime(timerVM.remainingTime))
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundColor(.primary)
            }
            .frame(width: 240, height: 240)
            
            // Slider for duration
            VStack(spacing: 12) {
                Text("Timer duration : \(timerVM.formatTime(timerVM.totalTime))")
                    .foregroundColor(.primary)
                
                Slider(value: $timerVM.totalTime, in: timerVM.sliderStep...1800, step: timerVM.sliderStep)
                    .tint(.blue)
                    .disabled(timerVM.timerState == .running)
                    .onChange(of: timerVM.totalTime) { newValue in
                        // Reset remaining time when changing duration
                        if timerVM.timerState == .stopped {
                            timerVM.remainingTime = newValue
                        }
                    }
            }
            .padding(.horizontal)
            
            // Picker for repetitions
            VStack(spacing: 10) {
                Picker("Number of timers :", selection: $timerVM.numberOfTimers) {
                    ForEach(1..<6) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .pickerStyle(.segmented)
                .tint(.blue)
                .disabled(timerVM.timerState == .running)
            }
            .padding(.horizontal)
            
            // Control buttons
            HStack(spacing: 16) {
                Button(action: {
                    haptic(.medium)
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
                .disabled(timerVM.timerState == .stopped && timerVM.remainingTime == timerVM.totalTime && timerVM.currentRepetition == 0)
                .opacity(timerVM.timerState == .stopped && timerVM.remainingTime == timerVM.totalTime && timerVM.currentRepetition == 0 ? 0.5 : 1)
                .scaleEffect(isResetPressed ? 0.92 : 1.0)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground).ignoresSafeArea())
    }
    
    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

#Preview {
    TimerView().environmentObject(TimerViewModel())
}

