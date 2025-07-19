//
//  pulseyApp.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI
import HealthKit

@main
struct pulseyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var workouts: [HKWorkout] = []

    var body: some Scene {
        WindowGroup {
            if let workout = workouts.last {
                WorkoutDetailView(workout: workout)
            } else {
                UserInfoView()
                    .task {
                        try? await HealthKitManager.shared.requestWorkoutAuthorization()
                        self.workouts = (try? await HealthKitManager.shared.fetchWorkouts()) ?? []
                    }
            }
        }
    }
}
