//
//  DeepLinkManager.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import SwiftUI

@Observable
final class DeepLinkManager {
    static let shared = DeepLinkManager()

    var selectedWorkoutID: String?
    var shouldNavigateToWorkout = false

    private init() {}

    /// 딥링크 처리
    /// 예시: "pulsey://workout?id=12345"
    static func handleDeepLink(_ url: URL) {
        print("🔗 딥링크 수신: \(url.absoluteString)")

        // pulsey scheme 확인
        guard url.scheme == "pulsey" else {
            print("🚫 잘못된 scheme: \(url.scheme ?? "nil")")
            return
        }

        // host 확인 (workout)
        guard url.host == "workout" else {
            print("🚫 잘못된 host: \(url.host ?? "nil")")
            return
        }

        // URL에서 쿼리 파라미터 파싱
        let urlString = url.absoluteString
        guard urlString.contains("id") else {
            print("🚫 id 파라미터가 없음")
            return
        }

        let components = URLComponents(string: url.absoluteString)
        let urlQueryItems = components?.queryItems ?? []

        var dictionaryData = [String: String]()
        urlQueryItems.forEach { dictionaryData[$0.name] = $0.value }

        guard let workoutID = dictionaryData["id"] else {
            print("🚫 id 값이 없음")
            return
        }

        print("🔗 운동 ID 파싱 성공: \(workoutID)")
        shared.navigateToWorkoutDetail(workoutID: workoutID)
    }

    /// 운동 상세 화면으로 이동
    private func navigateToWorkoutDetail(workoutID: String) {
        print("🔗 운동 상세 화면으로 이동: \(workoutID)")

        DispatchQueue.main.async {
            self.selectedWorkoutID = workoutID
            self.shouldNavigateToWorkout = true
        }
    }

    /// 네비게이션 완료 후 상태 리셋
    func resetNavigation() {
        selectedWorkoutID = nil
        shouldNavigateToWorkout = false
    }
}
