import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    @Published var isAuthorized = false
    @Published var waterReminderEnabled = true
    @Published var walkingReminderEnabled = true
    @Published var waterInterval: TimeInterval = 3600 // 1 hour
    @Published var walkingInterval: TimeInterval = 1800 // 30 minutes
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
        checkAuthorization()
    }
    
    // MARK: - Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if granted {
                    self.scheduleNotifications()
                }
            }
        }
    }
    
    private func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Notification Scheduling
    func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if waterReminderEnabled {
            scheduleWaterReminders()
        }
        
        if walkingReminderEnabled {
            scheduleWalkingReminders()
        }
    }
    
    private func scheduleWaterReminders() {
        let messages = [
            "💧 Time to hydrate! Your body needs water to stay healthy.",
            "🌊 Don't forget to drink water! Stay refreshed and focused.",
            "💦 Water break! Keep your energy levels up.",
            "🚰 Hydration reminder: A glass of water keeps you going!",
            "💧 Your body is calling for water! Time for a healthy sip."
        ]
        
        for i in 0..<24 { // Schedule for next 24 hours
            let content = UNMutableNotificationContent()
            content.title = "Water Reminder"
            content.body = messages.randomElement() ?? "Time to drink water!"
            content.sound = .default
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: waterInterval * Double(i + 1),
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "water-reminder-\(i)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    private func scheduleWalkingReminders() {
        let messages = [
            "🚶‍♂️ Time to move! Take a short walk to boost your energy.",
            "🏃‍♀️ Walking break! Your body needs movement.",
            "🌿 Get up and stretch! A little movement goes a long way.",
            "🚶‍♀️ Step away from your desk! Time for a healthy walk.",
            "🏃‍♂️ Movement matters! Take a few minutes to walk around."
        ]
        
        for i in 0..<48 { // Schedule for next 24 hours
            let content = UNMutableNotificationContent()
            content.title = "Walking Reminder"
            content.body = messages.randomElement() ?? "Time to take a walk!"
            content.sound = .default
            content.badge = 1
            
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: walkingInterval * Double(i + 1),
                repeats: false
            )
            
            let request = UNNotificationRequest(
                identifier: "walking-reminder-\(i)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    // MARK: - Settings Management
    func updateSettings() {
        saveSettings()
        if isAuthorized {
            scheduleNotifications()
        }
    }
    
    private func saveSettings() {
        userDefaults.set(waterReminderEnabled, forKey: "waterReminderEnabled")
        userDefaults.set(walkingReminderEnabled, forKey: "walkingReminderEnabled")
        userDefaults.set(waterInterval, forKey: "waterInterval")
        userDefaults.set(walkingInterval, forKey: "walkingInterval")
    }
    
    private func loadSettings() {
        waterReminderEnabled = userDefaults.bool(forKey: "waterReminderEnabled")
        walkingReminderEnabled = userDefaults.bool(forKey: "walkingReminderEnabled")
        
        let savedWaterInterval = userDefaults.double(forKey: "waterInterval")
        if savedWaterInterval > 0 {
            waterInterval = savedWaterInterval
        }
        
        let savedWalkingInterval = userDefaults.double(forKey: "walkingInterval")
        if savedWalkingInterval > 0 {
            walkingInterval = savedWalkingInterval
        }
    }
}