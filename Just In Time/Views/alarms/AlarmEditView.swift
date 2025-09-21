//
//  AlarmEditView.swift
//  Just In Time
//
//  Created by Antoine LEPRETRE on 21/09/2025.
//


// Views/alarms/AlarmEditView.swift
import SwiftUI

struct AlarmEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State var alarm: Alarm
    var onSave: (Alarm) -> Void

    @State private var repeatDays: Set<Int> = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                DatePicker("", selection: Binding(
                    get: { alarm.time },
                    set: { alarm.time = $0 }
                ), displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .liquidGlass(corner: 28)

                VStack(spacing: 12) {
                    TextField("Libellé", text: Binding(get: { alarm.label }, set: { alarm.label = $0 }))
                        .textFieldStyle(.roundedBorder)
                    Toggle("Vibreur", isOn: Binding(get: { alarm.vibrate }, set: { alarm.vibrate = $0 }))
                    Toggle("Activer", isOn: Binding(get: { alarm.enabled }, set: { alarm.enabled = $0 }))
                }
                .liquidGlass()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Répétition").font(.headline)
                    DaysPicker(selection: Binding(get: { alarm.repeatDays }, set: { alarm.repeatDays = $0 }))
                }
                .liquidGlass()

                Spacer()
            }
            .padding()
            .navigationTitle("Modifier alarme")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Enregistrer") {
                        onSave(alarm)
                        dismiss()
                    }.fontWeight(.semibold)
                }
            }
        }
    }
}

private struct DaysPicker: View {
    @Binding var selection: Set<Int> // 0..6 (Dim..Sam)

    let labels = Calendar.current.weekdaySymbols // Dim..Sam

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<7, id: \.self) { i in
                let isOn = selection.contains(i)
                Button {
                    if isOn { selection.remove(i) } else { selection.insert(i) }
                    Haptics.tap()
                } label: {
                    Text(String(labels[i].prefix(1)))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(isOn ? Color.white.opacity(0.25) : Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
