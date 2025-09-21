import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            
            StopwatchView()
                .tabItem {
                    Label("Stopwatch", systemImage: "stopwatch")
                }
            
            AlarmsView()
                .tabItem {
                    Label("Alarms", systemImage: "alarm")
                }
        }
        .tint(.blue)
    }
}
#Preview {
    ContentView()
}
