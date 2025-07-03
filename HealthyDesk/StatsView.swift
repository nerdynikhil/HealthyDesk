import SwiftUI
import CoreData

struct StatsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterEntry.timestamp, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<WaterEntry>

    var todayTotal: Double {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.filter { $0.timestamp >= today }.reduce(0) { $0 + $1.amount }
    }
    var weekTotal: Double {
        let weekAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()
        return entries.filter { $0.timestamp >= weekAgo }.reduce(0) { $0 + $1.amount }
    }
    var weekAverage: Double { weekTotal / 7 }
    var streak: Int {
        // MVP: just return 1 if todayTotal > 0
        todayTotal > 0 ? 1 : 0
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Today's Total: \(Int(todayTotal)) ml")
                .font(.title2)
            Text("Weekly Average: \(Int(weekAverage)) ml")
                .font(.title2)
            Text("Current Streak: \(streak) days")
                .font(.title2)
            Spacer()
        }
        .padding()
    }
} 