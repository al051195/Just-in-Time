import SwiftUI

struct AlarmEditView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AlarmsViewModel
    @State private var selectedTime: Date = Date()
    @State private var isEnabled: Bool = true
    private var alarmToEdit: Alarm? = nil
    
    init(viewModel: AlarmsViewModel, alarm: Alarm? = nil) {
        self.viewModel = viewModel
        self.alarmToEdit = alarm
        _selectedTime = State(initialValue: alarm?.time ?? Date())
        _isEnabled = State(initialValue: alarm?.enabled ?? true)
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(alarmToEdit == nil ? "Nouvelle alarme" : "Modifier l’alarme")
                .font(.title2)
                .bold()
                .padding(.top)
            
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.horizontal)
            
            Toggle("Activer l’alarme", isOn: $isEnabled)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 16) {
                Button("Annuler") { dismiss() }
                    .frame(maxWidth: .infinity, minHeight: 55)
                    .buttonStyle(.glassProminent)
                    .tint(.red)
                
                Button(alarmToEdit == nil ? "Ajouter" : "Mettre à jour") {
                    let newAlarm = Alarm(id: alarmToEdit?.id ?? UUID(), time: selectedTime, enabled: isEnabled)
                    if alarmToEdit != nil { viewModel.update(newAlarm) } else { viewModel.add(newAlarm) }
                    dismiss()
                }
                .frame(maxWidth: .infinity, minHeight: 55)
                .buttonStyle(.glassProminent)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(40)}
}
