//
//  LocalPushNotification.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import UserNotifications

struct LocalPushNotification {
    let identifier: String
    let title: String
    let body: String
    let deepLink: String?

    init(identifier: String, title: String, body: String, deepLink: String? = nil) {
        self.identifier = identifier
        self.title = title
        self.body = body
        self.deepLink = deepLink
    }

    func toNotificationRequest() -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // 딥링크 정보 추가
        if let deepLink = deepLink {
            content.userInfo = ["deepLink": deepLink]
        }

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: nil // 즉시 발송
        )

        return request
    }
}
