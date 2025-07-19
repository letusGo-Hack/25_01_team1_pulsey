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
    @AppStorage("didFinishOnboarding") var didFinishOnboarding: Bool = false
    @AppStorage("didSelectTrainer") var didSelectTrainer: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            if !didFinishOnboarding {
                UserInfoView()
                    .launchScreen {
                        LaunchScreenView()
                    }
                    .task {
                        _ = await NotificationManager.requestNotificationPermission()
                        try? await HealthKitManager.shared.requestWorkoutAuthorization()
                        let _ = try? await HealthKitManager.shared.startObservingWorkouts()
                    }
                    .onOpenURL { url in
                        DeepLinkManager.handleDeepLink(url)
                    }
            } else if !didSelectTrainer {
                SelectCharacterView()
            } else {
                MainView()
                    .task {
                        _ = await NotificationManager.requestNotificationPermission()
                        try? await HealthKitManager.shared.requestWorkoutAuthorization()
                        let _ = try? await HealthKitManager.shared.startObservingWorkouts()
                    }
                    .onOpenURL { url in
                        DeepLinkManager.handleDeepLink(url)
                    }
            }
        }
    }
}
