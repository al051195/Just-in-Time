import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AlarmsView()
                .tabItem {
                    Label("Alarms", systemImage: "alarm")
                }
            
            TimerView()
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
            
            StopwatchView()
                .tabItem {
                    Label("Stopwatch", systemImage: "stopwatch")
                }
        }
        .tint(.blue)
    }
}
#Preview {
    ContentView()
        .environmentObject(StopwatchViewModel())
        .environmentObject(AlarmsViewModel())
        .environmentObject(TimerViewModel())
}
