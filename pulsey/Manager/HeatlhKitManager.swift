//
//  HealthKitManager.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import HealthKit

final class HealthKitManager {
    static let shared = HealthKitManager()

    private let store = HKHealthStore()
    private var isObservingWorkouts = false
    private var latestPushedWorkoutID: String? {
        get { UserDefaults.standard.string(forKey: "latestPushedWorkoutID") }
        set { UserDefaults.standard.set(newValue, forKey: "latestPushedWorkoutID") }
    }

    private init() {}

    // 시뮬레이터 환경 확인
    private var isSimulator: Bool {
#if targetEnvironment(simulator)
        return true
#else
        return false
#endif
    }

    // 운동 데이터 권한 요청
    func requestWorkoutAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else { return }

        // 시뮬레이터에서는 권한 요청을 스킵
        if isSimulator {
            return
        }

        let workoutType = HKObjectType.workoutType()
        try await store.requestAuthorization(toShare: [], read: [workoutType])
    }

    // 운동 데이터 받아오기
    func fetchWorkouts() async throws -> [HKWorkout] {
        // 시뮬레이터 환경에서는 목데이터 반환
        if isSimulator {
            return .mock()
        }

        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let predicate: NSPredicate? = nil

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let workouts = samples as? [HKWorkout] ?? []
                continuation.resume(returning: workouts)
            }
            store.execute(query)
        }
    }

    // MARK: - 운동 관찰 기능 추가

    /// 헬스킷 운동 데이터를 관찰하고 새로운 운동이 추가될 때마다 로컬 푸시를 발송
    func startObservingWorkouts() async throws {
        // 이미 관찰 중이면 중복 실행하지 않음
        guard !isObservingWorkouts else { return }

        // 시뮬레이터에서는 스킵
        guard !isSimulator else { return }

        let workoutType = HKObjectType.workoutType()

        // 백그라운드 전송 활성화
        try await store.enableBackgroundDelivery(for: workoutType, frequency: .immediate)
        isObservingWorkouts = true

        // 관찰 쿼리 시작
        try await observeWorkoutUpdates()
    }

    /// 운동 데이터 변경사항을 관찰
    private func observeWorkoutUpdates() async throws {
        let workoutType = HKObjectType.workoutType()

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKObserverQuery(sampleType: workoutType, predicate: nil) { [weak self] query, completionHandler, error in
                guard let self = self else {
                    completionHandler()
                    return
                }

                if let error = error {
                    print("🐛 운동 관찰 에러: \(error)")
                    completionHandler()
                    return
                }

                print("🏋️‍♀️ Observed Workout Update")

                // 최근 운동 데이터 확인
                Task {
                    await self.checkRecentWorkoutAndSendNotification()
                    completionHandler()
                }
            }

            self.store.execute(query)
            continuation.resume()
        }
    }

    /// 최근 운동을 확인하고 필요시 알림 전송
    private func checkRecentWorkoutAndSendNotification() async {
        do {
            // 최근 10분 이내의 운동 확인
            let tenMinutesAgo = Date().addingTimeInterval(-10 * 60)
            let predicate = HKQuery.predicateForSamples(withStart: tenMinutesAgo, end: nil, options: .strictStartDate)

            let workouts = try await fetchWorkoutsWithPredicate(predicate)
            guard let latestWorkout = workouts.first else { return }

            print("🏋️‍♀️👀 Observed Workout: \(latestWorkout.workoutActivityType.name) \(latestWorkout)")

            await sendNotificationIfNeeded(for: latestWorkout)
        } catch {
            print("🐛 최근 운동 확인 에러: \(error)")
        }
    }

    /// 특정 조건의 운동 데이터 가져오기
    private func fetchWorkoutsWithPredicate(_ predicate: NSPredicate?) async throws -> [HKWorkout] {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: workoutType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                let workouts = samples as? [HKWorkout] ?? []
                continuation.resume(returning: workouts)
            }
            store.execute(query)
        }
    }

    /// 필요시 알림 전송
    private func sendNotificationIfNeeded(for workout: HKWorkout) async {
        let workoutID = workout.uuid.uuidString

        // 이미 푸시를 보낸 운동이라면 무시
        guard workoutID != latestPushedWorkoutID else {
            print("🏋️‍♀️ Notification already sent for: \(workout.workoutActivityType.name)")
            return
        }

        // 최근 전송된 운동 ID 업데이트
        latestPushedWorkoutID = workoutID

        // 알림 생성 및 전송
        let notification = createWorkoutNotification(from: workout)
        NotificationManager.fireLocalPushNotification(notification)

        print("🏋️‍♀️ Notification sent for: \(workout.workoutActivityType.name)")
    }

    /// 운동 알림 생성
    private func createWorkoutNotification(from workout: HKWorkout) -> LocalPushNotification {
        let workoutName = (workout.workoutActivityType.associatedEmoji() ?? "") + workout.workoutActivityType.koreanName
        let duration = Int(workout.duration / 60) // 분 단위

        return LocalPushNotification(
            title: "운동 완료! 🎉",
            subtitle: nil,
            body: "\(workoutName) \(duration)분 운동을 완료했습니다!",
            deepLink: "pulsey://workout/\(workout.uuid.uuidString)"
        )
    }

    /// 운동 관찰 중단
    func stopObservingWorkouts() {
        guard isObservingWorkouts else { return }

        let workoutType = HKObjectType.workoutType()
        store.disableBackgroundDelivery(for: workoutType) { success, error in
            if let error = error {
                print("🐛 백그라운드 전송 비활성화 에러: \(error)")
            }
        }

        isObservingWorkouts = false
    }
}
