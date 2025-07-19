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

    var body: some Scene {
        WindowGroup {
            MainView()
                .task {
                    try? await HealthKitManager.shared.requestWorkoutAuthorization()
                }
                .onOpenURL { url in
                    DeepLinkManager.handleDeepLink(url)
                }
        }
    }
}
