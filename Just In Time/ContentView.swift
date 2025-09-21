import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerView()
                .tabItem { Label("Minuteur", systemImage: "timer") }

            StopwatchView()
                .tabItem { Label("Chrono", systemImage: "stopwatch") }

            AlarmView() 
                .tabItem { Label("Alarmes", systemImage: "alarm") }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AlarmsViewModel())
        .environmentObject(TimerViewModel())
        .environmentObject(StopwatchViewModel())
}

