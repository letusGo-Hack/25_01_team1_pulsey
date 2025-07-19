//
//  LocalPushNotification.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import UserNotifications

public struct LocalPushNotification {
    /// 알림의 제목
    let title: String
    /// 제목 아래에 표시되는 부제목
    let subtitle: String?
    /// 부제목 아래에 표시되는 본문 내용
    let body: String?
}

// MARK: - UNNotificationRequest Conversion

public extension LocalPushNotification {
    func toNotificationRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title

        if let subtitle {
            content.subtitle = subtitle
        }

        if let body {
            content.body = body
        }

        return UNNotificationRequest(
            identifier: .init(),
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )
    }
}
