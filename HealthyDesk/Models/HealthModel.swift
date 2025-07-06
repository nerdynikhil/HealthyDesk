import Foundation

struct WaterEntry {
    let id = UUID()
    let amount: Double // in ml
    let timestamp: Date
}

struct WalkingEntry {
    let id = UUID()
    let duration: TimeInterval // in seconds
    let timestamp: Date
}

struct DailyStats {
    let date: Date
    let waterIntake: Double // in ml
    let walkingTime: TimeInterval // in seconds
    let waterGoal: Double // in ml
    let walkingGoal: TimeInterval // in seconds
    
    var waterProgress: Double {
        return waterIntake / waterGoal
    }
    
    var walkingProgress: Double {
        return walkingTime / walkingGoal
    }
}

class HealthModel: ObservableObject {
    @Published var waterEntries: [WaterEntry] = []
    @Published var walkingEntries: [WalkingEntry] = []
    @Published var dailyWaterGoal: Double = 2000 // 2L default
    @Published var dailyWalkingGoal: TimeInterval = 1800 // 30 minutes default
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
    }
    
    // MARK: - Water Management
    func addWater(amount: Double) {
        let entry = WaterEntry(amount: amount, timestamp: Date())
        waterEntries.append(entry)
        saveData()
    }
    
    func getTodayWaterIntake() -> Double {
        let today = Calendar.current.startOfDay(for: Date())
        return waterEntries
            .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(0) { $0 + $1.amount }
    }
    
    // MARK: - Walking Management
    func addWalk(duration: TimeInterval) {
        let entry = WalkingEntry(duration: duration, timestamp: Date())
        walkingEntries.append(entry)
        saveData()
    }
    
    func getTodayWalkingTime() -> TimeInterval {
        let today = Calendar.current.startOfDay(for: Date())
        return walkingEntries
            .filter { Calendar.current.isDate($0.timestamp, inSameDayAs: today) }
            .reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Daily Stats
    func getDailyStats() -> DailyStats {
        return DailyStats(
            date: Date(),
            waterIntake: getTodayWaterIntake(),
            walkingTime: getTodayWalkingTime(),
            waterGoal: dailyWaterGoal,
            walkingGoal: dailyWalkingGoal
        )
    }
    
    // MARK: - Data Persistence
    private func saveData() {
        if let waterData = try? JSONEncoder().encode(waterEntries) {
            userDefaults.set(waterData, forKey: "waterEntries")
        }
        if let walkingData = try? JSONEncoder().encode(walkingEntries) {
            userDefaults.set(walkingData, forKey: "walkingEntries")
        }
        userDefaults.set(dailyWaterGoal, forKey: "dailyWaterGoal")
        userDefaults.set(dailyWalkingGoal, forKey: "dailyWalkingGoal")
    }
    
    private func loadData() {
        if let waterData = userDefaults.data(forKey: "waterEntries"),
           let loadedWaterEntries = try? JSONDecoder().decode([WaterEntry].self, from: waterData) {
            waterEntries = loadedWaterEntries
        }
        
        if let walkingData = userDefaults.data(forKey: "walkingEntries"),
           let loadedWalkingEntries = try? JSONDecoder().decode([WalkingEntry].self, from: walkingData) {
            walkingEntries = loadedWalkingEntries
        }
        
        dailyWaterGoal = userDefaults.double(forKey: "dailyWaterGoal")
        if dailyWaterGoal == 0 { dailyWaterGoal = 2000 }
        
        dailyWalkingGoal = userDefaults.double(forKey: "dailyWalkingGoal")
        if dailyWalkingGoal == 0 { dailyWalkingGoal = 1800 }
    }
}

// MARK: - Codable Extensions
extension WaterEntry: Codable {}
extension WalkingEntry: Codable {}