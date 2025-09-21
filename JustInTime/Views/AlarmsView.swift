import SwiftUI

struct AlarmsView: View {
    @EnvironmentObject var alarmsVM: AlarmsViewModel
    @State private var isEditing = false
    @State private var selectedAlarm: Alarm? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(alarmsVM.alarms) { alarm in
                    HStack {
                        Text(alarm.time, style: .time)
                        Spacer()
                        Toggle("", isOn: Binding(get: { alarm.enabled }, set: { newValue in
                            var updated = alarm
                            updated.enabled = newValue
                            alarmsVM.update(updated)
                        }))
                        .labelsHidden()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedAlarm = alarm
                        isEditing = true
                    }
                }
                .onDelete(perform: alarmsVM.delete)
            }
            .navigationTitle("Alarmes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedAlarm = nil
                        isEditing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                AlarmEditView(viewModel: alarmsVM, alarm: selectedAlarm)
                    .presentationBackground(.clear)
            }
        }
    }
}

#Preview {
    AlarmsView().environmentObject(AlarmsViewModel())
}
