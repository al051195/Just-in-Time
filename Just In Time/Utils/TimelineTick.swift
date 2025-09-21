import SwiftUI

/// Petite aide pour animer les gradients "liquides"
struct TimelineTick: View {
    let period: Double
    @State private var phase: Double = 0

    var body: some View {
        Rectangle().fill(.clear)
            .onAppear { animate() }
    }

    private func animate() {
        withAnimation(.linear(duration: period).repeatForever(autoreverses: false)) {
            phase = 1
        }
    }
}
