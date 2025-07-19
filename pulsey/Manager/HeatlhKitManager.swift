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
}
