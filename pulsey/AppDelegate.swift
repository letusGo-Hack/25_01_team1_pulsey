//
//  AppDelegate.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    /// 앱이 foreground에 있을 때 알림이 오는 경우
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
    
    /// 알림을 탭했을 때 처리
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if let deepLinkString = response.notification.request.content.userInfo["deepLink"] as? String,
           let deepLinkURL = URL(string: deepLinkString) {
            DeepLinkManager.handleDeepLink(deepLinkURL)
        }
        completionHandler()
    }
}
