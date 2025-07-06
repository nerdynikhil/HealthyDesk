//
//  ContentView.swift
//  HealthyDesk
//
//  Created by Nikhil Barik on 20/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var healthModel = HealthModel()
    @StateObject private var notificationManager = NotificationManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(healthModel: healthModel, notificationManager: notificationManager)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            StatsView(healthModel: healthModel)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
                .tag(1)
            
            SettingsView(healthModel: healthModel, notificationManager: notificationManager)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .onAppear {
            if !notificationManager.isAuthorized {
                notificationManager.requestAuthorization()
            }
        }
    }
}

struct HomeView: View {
    @ObservedObject var healthModel: HealthModel
    @ObservedObject var notificationManager: NotificationManager
    @State private var showingWaterSheet = false
    @State private var showingWalkSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("HealthyDesk")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Stay healthy while you work")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Daily Progress Cards
                    VStack(spacing: 20) {
                        WaterProgressCard(
                            healthModel: healthModel,
                            onTap: { showingWaterSheet = true }
                        )
                        
                        WalkingProgressCard(
                            healthModel: healthModel,
                            onTap: { showingWalkSheet = true }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Quick Actions
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Actions")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 15) {
                            QuickActionButton(
                                title: "Drink Water",
                                icon: "drop.fill",
                                color: .blue,
                                action: { healthModel.addWater(amount: 250) }
                            )
                            
                            QuickActionButton(
                                title: "5 Min Walk",
                                icon: "figure.walk",
                                color: .green,
                                action: { healthModel.addWalk(duration: 300) }
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingWaterSheet) {
            WaterEntrySheet(healthModel: healthModel)
        }
        .sheet(isPresented: $showingWalkSheet) {
            WalkEntrySheet(healthModel: healthModel)
        }
    }
}

struct WaterProgressCard: View {
    @ObservedObject var healthModel: HealthModel
    let onTap: () -> Void
    
    var body: some View {
        let stats = healthModel.getDailyStats()
        
        Button(action: onTap) {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Water Intake")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(Int(stats.waterIntake))ml / \(Int(stats.waterGoal))ml")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: min(stats.waterProgress, 1.0))
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                        
                        Image(systemName: "drop.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                
                ProgressView(value: min(stats.waterProgress, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WalkingProgressCard: View {
    @ObservedObject var healthModel: HealthModel
    let onTap: () -> Void
    
    var body: some View {
        let stats = healthModel.getDailyStats()
        
        Button(action: onTap) {
            VStack(spacing: 15) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Walking Time")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(Int(stats.walkingTime / 60))min / \(Int(stats.walkingGoal / 60))min")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.green.opacity(0.3), lineWidth: 8)
                            .frame(width: 60, height: 60)
                        
                        Circle()
                            .trim(from: 0, to: min(stats.walkingProgress, 1.0))
                            .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                            .frame(width: 60, height: 60)
                            .rotationEffect(.degrees(-90))
                        
                        Image(systemName: "figure.walk")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
                
                ProgressView(value: min(stats.walkingProgress, 1.0))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
