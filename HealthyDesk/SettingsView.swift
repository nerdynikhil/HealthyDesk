import SwiftUI

struct SettingsView: View {
    @State private var dailyGoal: Double = 2000
    @State private var notificationsEnabled: Bool = true
    var body: some View {
        Form {
            Section(header: Text("Daily Goal")) {
                HStack {
                    Text("Goal")
                    Spacer()
                    TextField("ml", value: $dailyGoal, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .frame(width: 80)
                }
            }
            Section(header: Text("Notifications")) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("Enable Reminders")
                }
            }
        }
    }
} 