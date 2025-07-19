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
    @State private var deepLinkManager = DeepLinkManager.shared

    var body: some Scene {
        WindowGroup {
            VStack {
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
            .onOpenURL { url in
                DeepLinkManager.handleDeepLink(url)
            }
        }
    }
}
