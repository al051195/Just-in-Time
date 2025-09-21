import SwiftUI
import UIKit

struct StopwatchView: View {
    @EnvironmentObject var stopwatchVM: StopwatchViewModel
    @State private var isStartPressed = false
    @State private var isResetPressed = false
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 18)
                    .opacity(0.15)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0, to: CGFloat(min(stopwatchVM.elapsed.truncatingRemainder(dividingBy: 60) / 60.0, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 0.05), value: stopwatchVM.elapsed)
                
                Text(stopwatchVM.formattedTime)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
            }
            .frame(width: 240, height: 240)
            
            HStack(spacing: 16) {
                Button(action: {
                    haptic(.heavy)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { isStartPressed = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { isStartPressed = false } }
                    stopwatchVM.isRunning ? stopwatchVM.stop() : stopwatchVM.start()
                }) {
                    Text(stopwatchVM.isRunning ? "Pause" : "Start")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(stopwatchVM.isRunning ? .orange : .blue)
                .scaleEffect(isStartPressed ? 0.92 : 1.0)
                
                Button(action: {
                    haptic(.medium)
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) { isResetPressed = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { isResetPressed = false } }
                    stopwatchVM.reset()
                }) {
                    Text("Reset")
                        .frame(width: 120, height: 44)
                }
                .buttonStyle(.glassProminent)
                .tint(.red)
                .disabled(stopwatchVM.elapsed == 0)
                .opacity(stopwatchVM.elapsed == 0 ? 0.5 : 1)
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
    StopwatchView().environmentObject(StopwatchViewModel())
}
