import SwiftUI

struct WaterEntrySheet: View {
    @ObservedObject var healthModel: HealthModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAmount: Double = 250
    @State private var customAmount: String = ""
    @State private var showingCustomInput = false
    
    private let presetAmounts: [Double] = [125, 250, 500, 750, 1000]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Add Water Intake")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Stay hydrated throughout the day")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Preset Amounts
                VStack(alignment: .leading, spacing: 15) {
                    Text("Quick Selection")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        ForEach(presetAmounts, id: \.self) { amount in
                            Button(action: {
                                selectedAmount = amount
                                showingCustomInput = false
                            }) {
                                VStack(spacing: 5) {
                                    Text("\(Int(amount))ml")
                                        .font(.headline)
                                        .foregroundColor(selectedAmount == amount ? .white : .blue)
                                    
                                    Text(getAmountDescription(amount))
                                        .font(.caption)
                                        .foregroundColor(selectedAmount == amount ? .white.opacity(0.8) : .secondary)
                                }
                                .frame(maxWidth: .infinity, minHeight: 60)
                                .background(selectedAmount == amount ? Color.blue : Color.blue.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Custom Amount
                VStack(alignment: .leading, spacing: 15) {
                    Text("Custom Amount")
                        .font(.headline)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextField("Enter amount", text: $customAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .onChange(of: customAmount) { newValue in
                                if !newValue.isEmpty {
                                    showingCustomInput = true
                                    if let amount = Double(newValue) {
                                        selectedAmount = amount
                                    }
                                }
                            }
                        
                        Text("ml")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Current Selection
                VStack(spacing: 10) {
                    Text("Selected Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(selectedAmount))ml")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                .padding(20)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Add Button
                Button(action: {
                    healthModel.addWater(amount: selectedAmount)
                    dismiss()
                }) {
                    Text("Add Water Intake")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Water Intake")
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
    
    private func getAmountDescription(_ amount: Double) -> String {
        switch amount {
        case 125: return "Small Cup"
        case 250: return "Regular Cup"
        case 500: return "Bottle"
        case 750: return "Large Bottle"
        case 1000: return "1 Liter"
        default: return "Custom"
        }
    }
}

#Preview {
    WaterEntrySheet(healthModel: HealthModel())
}