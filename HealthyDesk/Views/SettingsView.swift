import SwiftUI

struct SettingsView: View {
    @ObservedObject var healthModel: HealthModel
    @ObservedObject var notificationManager: NotificationManager
    @State private var showingGoalSheet = false
    @State private var showingNotificationSheet = false
    @State private var showingAboutSheet = false
    
    var body: some View {
        NavigationView {
            List {
                // Daily Goals Section
                Section(header: Text("Daily Goals")) {
                    SettingsRow(
                        icon: "drop.fill",
                        iconColor: .blue,
                        title: "Water Goal",
                        value: "\(Int(healthModel.dailyWaterGoal))ml",
                        action: { showingGoalSheet = true }
                    )
                    
                    SettingsRow(
                        icon: "figure.walk",
                        iconColor: .green,
                        title: "Walking Goal",
                        value: "\(Int(healthModel.dailyWalkingGoal / 60))min",
                        action: { showingGoalSheet = true }
                    )
                }
                
                // Notifications Section
                Section(header: Text("Notifications")) {
                    SettingsRow(
                        icon: "bell.fill",
                        iconColor: .orange,
                        title: "Notification Settings",
                        value: notificationManager.isAuthorized ? "Enabled" : "Disabled",
                        action: { showingNotificationSheet = true }
                    )
                    
                    if notificationManager.isAuthorized {
                        HStack {
                            Image(systemName: "drop.fill")
                                .foregroundColor(.blue)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Water Reminders")
                                    .font(.subheadline)
                                
                                Text("Every \(Int(notificationManager.waterInterval / 60)) minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $notificationManager.waterReminderEnabled)
                                .onChange(of: notificationManager.waterReminderEnabled) { _ in
                                    notificationManager.updateSettings()
                                }
                        }
                        .padding(.vertical, 2)
                        
                        HStack {
                            Image(systemName: "figure.walk")
                                .foregroundColor(.green)
                                .frame(width: 24, height: 24)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Walking Reminders")
                                    .font(.subheadline)
                                
                                Text("Every \(Int(notificationManager.walkingInterval / 60)) minutes")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: $notificationManager.walkingReminderEnabled)
                                .onChange(of: notificationManager.walkingReminderEnabled) { _ in
                                    notificationManager.updateSettings()
                                }
                        }
                        .padding(.vertical, 2)
                    }
                }
                
                // Data Section
                Section(header: Text("Data")) {
                    SettingsRow(
                        icon: "chart.bar.fill",
                        iconColor: .purple,
                        title: "Export Data",
                        value: "",
                        action: { exportData() }
                    )
                    
                    SettingsRow(
                        icon: "trash.fill",
                        iconColor: .red,
                        title: "Reset All Data",
                        value: "",
                        action: { resetData() }
                    )
                }
                
                // About Section
                Section(header: Text("About")) {
                    SettingsRow(
                        icon: "info.circle.fill",
                        iconColor: .blue,
                        title: "About HealthyDesk",
                        value: "Version 1.0",
                        action: { showingAboutSheet = true }
                    )
                    
                    SettingsRow(
                        icon: "heart.fill",
                        iconColor: .red,
                        title: "Rate the App",
                        value: "",
                        action: { rateApp() }
                    )
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showingGoalSheet) {
            GoalSettingsSheet(healthModel: healthModel)
        }
        .sheet(isPresented: $showingNotificationSheet) {
            NotificationSettingsSheet(notificationManager: notificationManager)
        }
        .sheet(isPresented: $showingAboutSheet) {
            AboutSheet()
        }
    }
    
    private func exportData() {
        // Implementation for exporting data
        // This would typically create a CSV or JSON file
        print("Export data functionality would be implemented here")
    }
    
    private func resetData() {
        // Implementation for resetting all data
        healthModel.waterEntries.removeAll()
        healthModel.walkingEntries.removeAll()
        print("All data has been reset")
    }
    
    private func rateApp() {
        // Implementation for rating the app
        // This would typically open the App Store
        print("Rate app functionality would be implemented here")
    }
}

struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if !value.isEmpty {
                    Text(value)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct GoalSettingsSheet: View {
    @ObservedObject var healthModel: HealthModel
    @Environment(\.dismiss) private var dismiss
    @State private var waterGoal: Double
    @State private var walkingGoal: Double
    
    init(healthModel: HealthModel) {
        self.healthModel = healthModel
        self._waterGoal = State(initialValue: healthModel.dailyWaterGoal)
        self._walkingGoal = State(initialValue: healthModel.dailyWalkingGoal / 60) // Convert to minutes
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Water Goal")) {
                    HStack {
                        Text("Daily water intake goal")
                        Spacer()
                        Text("\(Int(waterGoal))ml")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $waterGoal, in: 500...4000, step: 250)
                        .accentColor(.blue)
                }
                
                Section(header: Text("Walking Goal")) {
                    HStack {
                        Text("Daily walking goal")
                        Spacer()
                        Text("\(Int(walkingGoal))min")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $walkingGoal, in: 15...120, step: 15)
                        .accentColor(.green)
                }
                
                Section(footer: Text("Recommended: 2L (2000ml) of water and 30 minutes of walking daily")) {
                    Button("Reset to Recommended") {
                        waterGoal = 2000
                        walkingGoal = 30
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Daily Goals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        healthModel.dailyWaterGoal = waterGoal
                        healthModel.dailyWalkingGoal = walkingGoal * 60 // Convert back to seconds
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct NotificationSettingsSheet: View {
    @ObservedObject var notificationManager: NotificationManager
    @Environment(\.dismiss) private var dismiss
    @State private var waterInterval: Double
    @State private var walkingInterval: Double
    
    init(notificationManager: NotificationManager) {
        self.notificationManager = notificationManager
        self._waterInterval = State(initialValue: notificationManager.waterInterval / 60) // Convert to minutes
        self._walkingInterval = State(initialValue: notificationManager.walkingInterval / 60) // Convert to minutes
    }
    
    var body: some View {
        NavigationView {
            Form {
                if !notificationManager.isAuthorized {
                    Section(footer: Text("Notifications are disabled. Enable them in Settings to receive reminders.")) {
                        Button("Enable Notifications") {
                            notificationManager.requestAuthorization()
                        }
                        .foregroundColor(.blue)
                    }
                } else {
                    Section(header: Text("Water Reminders")) {
                        Toggle("Enable water reminders", isOn: $notificationManager.waterReminderEnabled)
                        
                        if notificationManager.waterReminderEnabled {
                            HStack {
                                Text("Reminder frequency")
                                Spacer()
                                Text("Every \(Int(waterInterval)) minutes")
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $waterInterval, in: 15...240, step: 15)
                                .accentColor(.blue)
                        }
                    }
                    
                    Section(header: Text("Walking Reminders")) {
                        Toggle("Enable walking reminders", isOn: $notificationManager.walkingReminderEnabled)
                        
                        if notificationManager.walkingReminderEnabled {
                            HStack {
                                Text("Reminder frequency")
                                Spacer()
                                Text("Every \(Int(walkingInterval)) minutes")
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $walkingInterval, in: 15...120, step: 15)
                                .accentColor(.green)
                        }
                    }
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        notificationManager.waterInterval = waterInterval * 60 // Convert back to seconds
                        notificationManager.walkingInterval = walkingInterval * 60 // Convert back to seconds
                        notificationManager.updateSettings()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct AboutSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // App Icon and Info
                    VStack(spacing: 15) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        
                        Text("HealthyDesk")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Stay healthy while you work")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 30)
                    
                    // Features
                    VStack(spacing: 20) {
                        FeatureRow(
                            icon: "drop.fill",
                            iconColor: .blue,
                            title: "Water Reminders",
                            description: "Get reminded to stay hydrated throughout the day"
                        )
                        
                        FeatureRow(
                            icon: "figure.walk",
                            iconColor: .green,
                            title: "Walking Reminders",
                            description: "Take regular breaks to move and stay active"
                        )
                        
                        FeatureRow(
                            icon: "chart.bar.fill",
                            iconColor: .purple,
                            title: "Progress Tracking",
                            description: "Monitor your daily water and walking goals"
                        )
                        
                        FeatureRow(
                            icon: "bell.fill",
                            iconColor: .orange,
                            title: "Smart Notifications",
                            description: "Customizable reminders that fit your schedule"
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    // Credits
                    VStack(spacing: 10) {
                        Text("Made with ❤️ for your health")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("© 2024 HealthyDesk")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SettingsView(healthModel: HealthModel(), notificationManager: NotificationManager())
}