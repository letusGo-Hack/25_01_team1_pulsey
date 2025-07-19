//
//  MainView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI
import HealthKit

struct MainView: View {
    @State private var deepLinkManager = DeepLinkManager.shared
    @State private var workouts: [HKWorkout] = []

    var body: some View {
        TabView {
            Tab("홈", systemImage: "home") {
                HomeView()
            }
            Tab("대쉬보드", systemImage: "home") {
                Text("dashboard")
            }
        }
        .task {
            self.workouts = (try? await HealthKitManager.shared.fetchWorkouts()) ?? []
        }
//        .tabViewStyle(.sidebarAdaptable)
        .fullScreenCover(item: $deepLinkManager.selectedWorkoutID) { selectedWorkoutID in
            if let workout = workouts.first(where: { $0.uuid.uuidString == selectedWorkoutID }) {
                WorkoutDetailView(workout: workout)
            } else {
                WorkoutNotFoundView {
                    deepLinkManager.selectedWorkoutID = nil
                }
            }
        }
    }
}

#Preview {
    MainView()
}
