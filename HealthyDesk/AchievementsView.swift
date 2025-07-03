import SwiftUI

struct AchievementsView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Achievements")
                .font(.largeTitle)
            HStack(spacing: 16) {
                ForEach(0..<3) { i in
                    VStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.yellow)
                        Text("Badge \(i+1)")
                            .font(.caption)
                    }
                }
            }
            Text("\"Stay hydrated, stay healthy!\"")
                .italic()
                .padding(.top, 32)
            Spacer()
        }
        .padding()
    }
} 