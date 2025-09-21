//
//  AlarmView.swift
//  Just in Time
//
//  Created by Antoine LEPRETRE on 18/08/2025.
//

import SwiftUI

struct AlarmView: View {
    @State private var alarms: [Date] = []
    @State private var newAlarm: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(alarms, id: \.self) { alarm in
                        HStack {
                            Text(formatDate(alarm))
                                .font(.title3)
                                .bold()
                            Spacer()
                            Button(action: {
                                deleteAlarm(alarm)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                DatePicker("Nouvelle alarme", selection: $newAlarm, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(WheelDatePickerStyle())
                    .padding()
                
                Button("Ajouter") {
                    addAlarm()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Capsule()
                        .fill(Color.blue)
                        .shadow(color: Color.blue.opacity(0.7), radius: 12)
                )
                .padding()
            }
            .navigationTitle("Alarmes")
        }
    }
    
    private func addAlarm() {
        alarms.append(newAlarm)
    }
    
    private func deleteAlarm(_ alarm: Date) {
        alarms.removeAll { $0 == alarm }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
#Preview {
    AlarmView()
}
