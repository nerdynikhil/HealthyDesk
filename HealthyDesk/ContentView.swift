//
//  ContentView.swift
//  HealthyDesk
//
//  Created by Nikhil Barik on 20/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "drop.fill")
                    Text("Dashboard")
                }
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis")
                    Text("Stats")
                }
            AchievementsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Achievements")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
    }
}

struct DashboardView: View {
    var body: some View {
        Text("Dashboard")
    }
}

struct StatsView: View {
    var body: some View {
        Text("Stats")
    }
}

struct AchievementsView: View {
    var body: some View {
        Text("Achievements")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

#Preview {
    ContentView()
}
