//
//  HKWorkout+Mock.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation

import HealthKit

extension [HKWorkout] {
    static func mock() -> [HKWorkout] {
        let calendar = Calendar.current
        let now = Date()

        var mockWorkouts: [HKWorkout] = []

        // 러닝 운동 데이터
        let runningStartDate = calendar.date(byAdding: .hour, value: -2, to: now)!
        let runningEndDate = calendar.date(byAdding: .minute, value: -90, to: now)!
        let runningWorkout = HKWorkout(
            activityType: .running,
            start: runningStartDate,
            end: runningEndDate,
            duration: 1800, // 30분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 250),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: 5000),
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(runningWorkout)

        // 사이클링 운동 데이터
        let cyclingStartDate = calendar.date(byAdding: .day, value: -1, to: now)!
        let cyclingEndDate = calendar.date(byAdding: .hour, value: 1, to: cyclingStartDate)!
        let cyclingWorkout = HKWorkout(
            activityType: .cycling,
            start: cyclingStartDate,
            end: cyclingEndDate,
            duration: 2700, // 45분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 320),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: 15000),
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(cyclingWorkout)

        // 수영 운동 데이터
        let swimmingStartDate = calendar.date(byAdding: .day, value: -2, to: now)!
        let swimmingEndDate = calendar.date(byAdding: .minute, value: 60, to: swimmingStartDate)!
        let swimmingWorkout = HKWorkout(
            activityType: .swimming,
            start: swimmingStartDate,
            end: swimmingEndDate,
            duration: 3600, // 60분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 400),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: 2000),
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(swimmingWorkout)

        // 근력 운동 데이터 (거리 정보 없음)
        let strengthStartDate = calendar.date(byAdding: .day, value: -3, to: now)!
        let strengthEndDate = calendar.date(byAdding: .minute, value: 50, to: strengthStartDate)!
        let strengthWorkout = HKWorkout(
            activityType: .traditionalStrengthTraining,
            start: strengthStartDate,
            end: strengthEndDate,
            duration: 3000, // 50분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 280),
            totalDistance: nil,
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(strengthWorkout)

        // 요가 운동 데이터
        let yogaStartDate = calendar.date(byAdding: .day, value: -4, to: now)!
        let yogaEndDate = calendar.date(byAdding: .minute, value: 75, to: yogaStartDate)!
        let yogaWorkout = HKWorkout(
            activityType: .yoga,
            start: yogaStartDate,
            end: yogaEndDate,
            duration: 4500, // 75분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 180),
            totalDistance: nil,
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(yogaWorkout)

        // 하이킹 운동 데이터
        let hikingStartDate = calendar.date(byAdding: .day, value: -5, to: now)!
        let hikingEndDate = calendar.date(byAdding: .hour, value: 2, to: hikingStartDate)!
        let hikingWorkout = HKWorkout(
            activityType: .hiking,
            start: hikingStartDate,
            end: hikingEndDate,
            duration: 7200, // 2시간
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 600),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: 8000),
            metadata: [HKMetadataKeyWorkoutBrandName: "Mock Fitness App"]
        )
        mockWorkouts.append(hikingWorkout)

        return mockWorkouts
    }
}
