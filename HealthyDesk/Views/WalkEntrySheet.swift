import SwiftUI

struct WalkEntrySheet: View {
    @ObservedObject var healthModel: HealthModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDuration: TimeInterval = 300 // 5 minutes
    @State private var customMinutes: String = ""
    @State private var showingCustomInput = false
    
    private let presetDurations: [TimeInterval] = [300, 600, 900, 1200, 1800] // 5, 10, 15, 20, 30 minutes
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "figure.walk")
                        .font(.system(size: 50))
                        .foregroundColor(.green)
                    
                    Text("Add Walking Time")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Keep moving for better health")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Preset Durations
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Selection")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(presetDurations, id: \.self) { duration in
                            Button(action: {
                                selectedDuration = duration
                                showingCustomInput = false
                            }) {
                                VStack(spacing: 5) {
                                    Text("\(Int(duration / 60))min")
                                        .font(.headline)
                                        .foregroundColor(selectedDuration == duration ? .white : .green)
                                    
                                    Text(getDurationDescription(duration))
                                        .font(.caption)
                                        .foregroundColor(selectedDuration == duration ? .white.opacity(0.8) : .secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(selectedDuration == duration ? Color.green : Color.green.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Custom Duration
                VStack(alignment: .leading, spacing: 15) {
                    Text("Custom Duration")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Enter minutes", text: $customMinutes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: customMinutes) { newValue in
                                if !newValue.isEmpty {
                                    showingCustomInput = true
                                    if let minutes = Double(newValue) {
                                        selectedDuration = minutes * 60
                                    }
                                }
                            }
                        
                        Text("min")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Current Selection
                VStack(spacing: 10) {
                    Text("Selected Duration")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(selectedDuration / 60))min")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .padding(20)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Add Button
                Button(action: {
                    healthModel.addWalk(duration: selectedDuration)
                    dismiss()
                }) {
                    Text("Add Walking Time")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Walking Time")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func getDurationDescription(_ duration: TimeInterval) -> String {
        switch duration {
        case 300: return "Quick Walk"
        case 600: return "Short Walk"
        case 900: return "Nice Walk"
        case 1200: return "Good Walk"
        case 1800: return "Long Walk"
        default: return "Custom"
        }
    }
}

#Preview {
    WalkEntrySheet(healthModel: HealthModel())
}