import SwiftUI

struct StatsView: View {
    @ObservedObject var healthModel: HealthModel
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Time Range Selector
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Today's Summary
                    TodaysSummaryCard(healthModel: healthModel)
                        .padding(.horizontal, 20)
                    
                    // Weekly Overview
                    WeeklyOverviewCard(healthModel: healthModel)
                        .padding(.horizontal, 20)
                    
                    // Achievement Cards
                    AchievementSection(healthModel: healthModel)
                        .padding(.horizontal, 20)
                    
                    // Recent Activity
                    RecentActivitySection(healthModel: healthModel)
                        .padding(.horizontal, 20)
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Statistics")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct TodaysSummaryCard: View {
    @ObservedObject var healthModel: HealthModel
    
    var body: some View {
        let stats = healthModel.getDailyStats()
        
        VStack(spacing: 20) {
            Text("Today's Progress")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 20) {
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 6)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: min(stats.waterProgress, 1.0))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(stats.waterProgress * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    
                    Text("Water")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(stats.waterIntake))ml")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .stroke(Color.green.opacity(0.3), lineWidth: 6)
                            .frame(width: 80, height: 80)
                        
                        Circle()
                            .trim(from: 0, to: min(stats.walkingProgress, 1.0))
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        Text("\(Int(stats.walkingProgress * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                    
                    Text("Walking")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(stats.walkingTime / 60))min")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

struct WeeklyOverviewCard: View {
    @ObservedObject var healthModel: HealthModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("This Week")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            let weeklyData = getWeeklyData()
            
            HStack(spacing: 12) {
                ForEach(weeklyData, id: \.day) { dayData in
                    VStack(spacing: 8) {
                        Text(dayData.day)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        // Water bar
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 8, height: 40)
                            .overlay(
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.blue)
                                        .frame(width: 8, height: 40 * dayData.waterProgress)
                                }
                            )
                        
                        // Walking bar
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.green.opacity(0.3))
                            .frame(width: 8, height: 40)
                            .overlay(
                                VStack {
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.green)
                                        .frame(width: 8, height: 40 * dayData.walkingProgress)
                                }
                            )
                    }
                }
            }
            
            HStack {
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                    Text("Water")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Walking")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private func getWeeklyData() -> [DayData] {
        let calendar = Calendar.current
        let today = Date()
        var weekData: [DayData] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayName = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            
            let dayWaterEntries = healthModel.waterEntries.filter { 
                calendar.isDate($0.timestamp, inSameDayAs: date) 
            }
            let dayWalkingEntries = healthModel.walkingEntries.filter { 
                calendar.isDate($0.timestamp, inSameDayAs: date) 
            }
            
            let waterIntake = dayWaterEntries.reduce(0) { $0 + $1.amount }
            let walkingTime = dayWalkingEntries.reduce(0) { $0 + $1.duration }
            
            weekData.append(DayData(
                day: dayName,
                waterProgress: min(waterIntake / healthModel.dailyWaterGoal, 1.0),
                walkingProgress: min(walkingTime / healthModel.dailyWalkingGoal, 1.0)
            ))
        }
        
        return weekData.reversed()
    }
}

struct DayData {
    let day: String
    let waterProgress: Double
    let walkingProgress: Double
}

struct AchievementSection: View {
    @ObservedObject var healthModel: HealthModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Achievements")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                AchievementCard(
                    title: "Water Goal",
                    description: "Days completed",
                    value: getWaterGoalDays(),
                    icon: "drop.fill",
                    color: .blue
                )
                
                AchievementCard(
                    title: "Walking Goal",
                    description: "Days completed",
                    value: getWalkingGoalDays(),
                    icon: "figure.walk",
                    color: .green
                )
            }
        }
    }
    
    private func getWaterGoalDays() -> Int {
        let calendar = Calendar.current
        let today = Date()
        var completedDays = 0
        
        for i in 0..<30 { // Last 30 days
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayWaterEntries = healthModel.waterEntries.filter { 
                calendar.isDate($0.timestamp, inSameDayAs: date) 
            }
            let waterIntake = dayWaterEntries.reduce(0) { $0 + $1.amount }
            
            if waterIntake >= healthModel.dailyWaterGoal {
                completedDays += 1
            }
        }
        
        return completedDays
    }
    
    private func getWalkingGoalDays() -> Int {
        let calendar = Calendar.current
        let today = Date()
        var completedDays = 0
        
        for i in 0..<30 { // Last 30 days
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let dayWalkingEntries = healthModel.walkingEntries.filter { 
                calendar.isDate($0.timestamp, inSameDayAs: date) 
            }
            let walkingTime = dayWalkingEntries.reduce(0) { $0 + $1.duration }
            
            if walkingTime >= healthModel.dailyWalkingGoal {
                completedDays += 1
            }
        }
        
        return completedDays
    }
}

struct AchievementCard: View {
    let title: String
    let description: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .padding(15)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct RecentActivitySection: View {
    @ObservedObject var healthModel: HealthModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Recent Activity")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                let recentEntries = getRecentEntries()
                
                if recentEntries.isEmpty {
                    Text("No recent activity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(20)
                } else {
                    ForEach(recentEntries.prefix(5), id: \.id) { entry in
                        ActivityRow(entry: entry)
                    }
                }
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    private func getRecentEntries() -> [ActivityEntry] {
        var entries: [ActivityEntry] = []
        
        entries.append(contentsOf: healthModel.waterEntries.map { 
            ActivityEntry(
                id: $0.id,
                type: .water,
                value: $0.amount,
                timestamp: $0.timestamp
            )
        })
        
        entries.append(contentsOf: healthModel.walkingEntries.map { 
            ActivityEntry(
                id: $0.id,
                type: .walking,
                value: $0.duration,
                timestamp: $0.timestamp
            )
        })
        
        return entries.sorted { $0.timestamp > $1.timestamp }
    }
}

struct ActivityEntry {
    let id: UUID
    let type: ActivityType
    let value: Double
    let timestamp: Date
}

enum ActivityType {
    case water
    case walking
}

struct ActivityRow: View {
    let entry: ActivityEntry
    
    var body: some View {
        HStack {
            Image(systemName: entry.type == .water ? "drop.fill" : "figure.walk")
                .foregroundColor(entry.type == .water ? .blue : .green)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.type == .water ? "Water intake" : "Walking")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(formatValue(entry.value, type: entry.type))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(formatTime(entry.timestamp))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
    
    private func formatValue(_ value: Double, type: ActivityType) -> String {
        switch type {
        case .water:
            return "\(Int(value))ml"
        case .walking:
            return "\(Int(value / 60))min"
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    StatsView(healthModel: HealthModel())
}