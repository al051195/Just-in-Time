import SwiftUI
import UIKit

struct TimerView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
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
            
            VStack(spacing: 12) {
                Text("Durée par timer : \(timerVM.formatTime(timerVM.totalTime))")
                    .foregroundColor(.primary)
                Slider(value: $timerVM.totalTime, in: timerVM.sliderStep...1800)
                    .tint(.blue)
                    .disabled(timerVM.timerState == .running)
            }
            .padding(.horizontal)
            
            VStack(spacing: 10) {
                Picker("Nombre de timers", selection: $timerVM.numberOfTimers) {
                    ForEach(1..<6) { i in Text("\(i)").tag(i) }
                }
                .pickerStyle(.segmented)
                .tint(.blue)
                .disabled(timerVM.timerState == .running)
            }
            .padding(.horizontal)
            
            HStack(spacing: 16) {
                Button(action: {
                    haptic(.heavy)
                    if timerVM.timerState == .running { timerVM.stop() } else { timerVM.start() }
                }) {
                    Text(timerVM.timerState == .running ? "Pause" : "Start")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(timerVM.timerState == .running ? .orange : .blue)
                
                Button(action: {
                    haptic(.medium)
                    timerVM.reset()
                }) {
                    Text("Reset")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
                .disabled(timerVM.timerState == .stopped && timerVM.remainingTime == timerVM.totalTime && timerVM.currentRepetition == 0)
                .opacity(timerVM.timerState == .stopped && timerVM.remainingTime == timerVM.totalTime && timerVM.currentRepetition == 0 ? 0.5 : 1)
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
