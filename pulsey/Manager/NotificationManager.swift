//
//  NotificationManager.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import UserNotifications

enum NotificationManager {
    static func fireLocalPushNotification(_ notification: LocalPushNotification) {
        let request = notification.toNotificationRequest()
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("🐛 알림 전송 에러: \(error)")
            } else {
                print("✅ 알림 전송 성공: \(notification.title)")
            }
        }
    }

    /// 알림 권한 요청
    static func requestNotificationPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()

        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            return granted
        } catch {
            print("🐛 알림 권한 요청 에러: \(error)")
            return false
        }
    }

    /// 현재 알림 권한 상태 확인
    static func checkNotificationPermission() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }
}
