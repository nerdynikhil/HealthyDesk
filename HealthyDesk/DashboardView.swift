import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WaterEntry.timestamp, ascending: false)],
        animation: .default)
    private var entries: FetchedResults<WaterEntry>

    let dailyGoal: Double = 2000 // 2L default
    var totalToday: Double {
        let today = Calendar.current.startOfDay(for: Date())
        return entries.filter { $0.timestamp >= today }.reduce(0) { $0 + $1.amount }
    }
    var progress: Double { min(totalToday / dailyGoal, 1.0) }

    var body: some View {
        VStack(spacing: 24) {
            // Progress Ring
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 20)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color.red, Color.blue]), center: .center), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: progress)
                VStack {
                    Text("\(Int(totalToday)) ml")
                        .font(.system(size: 32, weight: .bold))
                    Text("of \(Int(dailyGoal)) ml")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 200, height: 200)
            // Quick Add Buttons
            HStack(spacing: 24) {
                ForEach([250, 500, 750], id: \ .self) { amount in
                    Button(action: { addWater(amount: Double(amount), type: "quick") }) {
                        Text("+\(amount)ml")
                            .font(.headline)
                            .padding()
                            .background(Capsule().fill(Color.blue.opacity(0.2)))
                    }
                }
                Button(action: { addWater(amount: 0, type: "custom") }) {
                    Image(systemName: "plus")
                        .font(.headline)
                        .padding()
                        .background(Capsule().fill(Color.green.opacity(0.2)))
                }
            }
            Spacer()
        }
        .padding()
    }

    func addWater(amount: Double, type: String) {
        if amount == 0 {
            // Show custom input (MVP: just add 300ml)
            WaterEntry.create(in: viewContext, amount: 300, type: "custom")
        } else {
            WaterEntry.create(in: viewContext, amount: amount, type: type)
        }
    }
} 