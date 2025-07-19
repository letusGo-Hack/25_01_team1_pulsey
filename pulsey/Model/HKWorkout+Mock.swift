//
//  HKWorkout+Mock.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import Foundation
import HealthKit

extension [HKWorkout] {
    static let mock: [HKWorkout] = {
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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Nike Run Club",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 8.5),
                HKMetadataKeyElevationAscended: HKQuantity(unit: .meter(), doubleValue: 45),
                HKMetadataKeyMaximumSpeed: HKQuantity(unit: .meter().unitDivided(by: .second()), doubleValue: 4.2), // 약 15km/h
                HKMetadataKeyIndoorWorkout: false,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false
            ]
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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Strava",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 7.2),
                HKMetadataKeyElevationAscended: HKQuantity(unit: .meter(), doubleValue: 120),
                HKMetadataKeyMaximumSpeed: HKQuantity(unit: .meter().unitDivided(by: .second()), doubleValue: 11.1), // 40km/h
                HKMetadataKeyIndoorWorkout: false,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false
            ]
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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "MySwimPro",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 6.8),
                HKMetadataKeySwimmingLocationType: HKWorkoutSwimmingLocationType.pool.rawValue,
                HKMetadataKeySwimmingStrokeStyle: HKSwimmingStrokeStyle.freestyle.rawValue,
                HKMetadataKeyLapLength: HKQuantity(unit: .meter(), doubleValue: 25),
                HKMetadataKeyIndoorWorkout: true,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false
            ]
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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Strong",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 5.5),
                HKMetadataKeyIndoorWorkout: true,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false,
                "WorkoutActivityName": "Full Body Workout"
            ]
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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Down Dog Yoga",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 3.2),
                HKMetadataKeyIndoorWorkout: true,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false,
                "WorkoutActivityName": "Vinyasa Flow",
                "YogaStyle": "Hatha"
            ]
        )
        mockWorkouts.append(yogaWorkout)

        // HIIT 운동 데이터 추가
        let hiitStartDate = calendar.date(byAdding: .day, value: -6, to: now)!
        let hiitEndDate = calendar.date(byAdding: .minute, value: 30, to: hiitStartDate)!
        let hiitWorkout = HKWorkout(
            activityType: .highIntensityIntervalTraining,
            start: hiitStartDate,
            end: hiitEndDate,
            duration: 1800, // 30분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 350),
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: "7 Minute Workout",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 9.5),
                HKMetadataKeyIndoorWorkout: true,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false,
                "WorkoutActivityName": "Tabata HIIT",
                "RoundCount": 8,
                "WorkTime": HKQuantity(unit: .second(), doubleValue: 20),
                "RestTime": HKQuantity(unit: .second(), doubleValue: 10)
            ]
        )
        mockWorkouts.append(hiitWorkout)

        // 테니스 운동 데이터 추가
        let tennisStartDate = calendar.date(byAdding: .day, value: -7, to: now)!
        let tennisEndDate = calendar.date(byAdding: .minute, value: 90, to: tennisStartDate)!
        let tennisWorkout = HKWorkout(
            activityType: .tennis,
            start: tennisStartDate,
            end: tennisEndDate,
            duration: 5400, // 90분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 420),
            totalDistance: HKQuantity(unit: .meter(), doubleValue: 3500),
            metadata: [
                HKMetadataKeyWorkoutBrandName: "TennisBot",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 7.0),
                HKMetadataKeyIndoorWorkout: false,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false,
                "MatchType": "Singles",
                "GameCount": 12,
                "SetCount": 3,
                "Score": "6-4, 3-6, 6-2"
            ]
        )
        mockWorkouts.append(tennisWorkout)

        // 실내 자전거 운동 데이터
        let indoorBikeStartDate = calendar.date(byAdding: .day, value: -8, to: now)!
        let indoorBikeEndDate = calendar.date(byAdding: .minute, value: 40, to: indoorBikeStartDate)!
        let indoorBikeWorkout = HKWorkout(
            activityType: .cycling,
            start: indoorBikeStartDate,
            end: indoorBikeEndDate,
            duration: 2400, // 40분
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 300),
            totalDistance: nil,
            metadata: [
                HKMetadataKeyWorkoutBrandName: "Peloton",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 7.8),
                HKMetadataKeyIndoorBikeDistance: HKQuantity(unit: .meter(), doubleValue: 16000),
                HKMetadataKeyFitnessMachineDuration: HKQuantity(unit: .second(), doubleValue: 2400),
                HKMetadataKeyIndoorWorkout: true,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false
            ]
        )
        mockWorkouts.append(indoorBikeWorkout)

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
            metadata: [
                HKMetadataKeyWorkoutBrandName: "AllTrails",
                HKMetadataKeyAverageMETs: HKQuantity(unit: .kilocalorie().unitDivided(by: .gramUnit(with: .kilo).unitMultiplied(by: .hour())), doubleValue: 6.5),
                HKMetadataKeyElevationAscended: HKQuantity(unit: .meter(), doubleValue: 450),
                HKMetadataKeyMaximumSpeed: HKQuantity(unit: .meter().unitDivided(by: .second()), doubleValue: 2.8),
                HKMetadataKeyIndoorWorkout: false,
                HKMetadataKeyTimeZone: "Asia/Seoul",
                HKMetadataKeyWasUserEntered: false,
                "DifficultyLevel": "Moderate",
                "MaxElevation": HKQuantity(unit: .meter(), doubleValue: 850),
                "AverageHeartRate": HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 125),
                "MaximumHeartRate": HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 165),
                "MinimumHeartRate": HKQuantity(unit: .count().unitDivided(by: .minute()), doubleValue: 95)
            ]
        )
        mockWorkouts.append(hikingWorkout)

        return mockWorkouts
    }()
}

// MARK: - 메타데이터 접근을 위한 확장
extension HKWorkout {
    var averageMETs: HKQuantity? {
        return metadata?[HKMetadataKeyAverageMETs] as? HKQuantity
    }

    var elevationAscended: HKQuantity? {
        return metadata?[HKMetadataKeyElevationAscended] as? HKQuantity
    }

    var maximumSpeed: HKQuantity? {
        return metadata?[HKMetadataKeyMaximumSpeed] as? HKQuantity
    }

    var isIndoorWorkout: Bool {
        return metadata?[HKMetadataKeyIndoorWorkout] as? Bool ?? false
    }

    var workoutBrandName: String? {
        return metadata?[HKMetadataKeyWorkoutBrandName] as? String
    }

    var lapLength: HKQuantity? {
        return metadata?[HKMetadataKeyLapLength] as? HKQuantity
    }

    var swimmingLocationType: HKWorkoutSwimmingLocationType? {
        guard let rawValue = metadata?[HKMetadataKeySwimmingLocationType] as? Int else { return nil }
        return HKWorkoutSwimmingLocationType(rawValue: rawValue)
    }

    var swimmingStrokeStyle: HKSwimmingStrokeStyle? {
        guard let rawValue = metadata?[HKMetadataKeySwimmingStrokeStyle] as? Int else { return nil }
        return HKSwimmingStrokeStyle(rawValue: rawValue)
    }

    var timeZone: String? {
        return metadata?[HKMetadataKeyTimeZone] as? String
    }

    var wasUserEntered: Bool {
        return metadata?[HKMetadataKeyWasUserEntered] as? Bool ?? false
    }

    var indoorBikeDistance: HKQuantity? {
        return metadata?[HKMetadataKeyIndoorBikeDistance] as? HKQuantity
    }

    var fitnessMachineDuration: HKQuantity? {
        return metadata?[HKMetadataKeyFitnessMachineDuration] as? HKQuantity
    }
}
