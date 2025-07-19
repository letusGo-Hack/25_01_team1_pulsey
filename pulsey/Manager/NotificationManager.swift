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
        UNUserNotificationCenter.current().add(request)
    }
}
