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
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            Tab("캘린더", systemImage: "calendar") {
                CalendarView()
            }
        }
        .task {
            self.workouts = (try? await HealthKitManager.shared.fetchWorkouts()) ?? []
        }
        .fullScreenCover(item: $deepLinkManager.selectedWorkoutID) { selectedWorkoutID in
            if let workout = workouts.first(where: { $0.uuid.uuidString == selectedWorkoutID }) {
                WorkoutDetailCoachingView(workout: workout) {
                    deepLinkManager.selectedWorkoutID = nil
                }
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
