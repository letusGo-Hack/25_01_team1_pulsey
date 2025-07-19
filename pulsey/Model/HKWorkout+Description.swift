//
//  HKWorkout+Duration.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import HealthKit

extension HKWorkout {
    /// 운동 정보를 한 줄로 요약한 문자열
    var summaryDescription: String {
        var components: [String] = []

        // 운동 타입
        let workoutName = workoutActivityType.koreanName
        components.append(workoutName)

        // 지속 시간
        if let formattedDuration = formattedDuration {
            components.append(formattedDuration)
        }

        // 활성 칼로리
        if let activeEnergyBurned = totalEnergyBurned {
            let calories = Int(activeEnergyBurned.doubleValue(for: .kilocalorie()))
            components.append("\(calories)kcal")
        }

        // 총 거리
        if let totalDistance = totalDistance {
            components.append(formattedDistance(totalDistance))
        }

        // 평균 심박수
        if let avgHeartRate = averageHeartRate {
            components.append("\(Int(avgHeartRate))BPM")
        }

        return components.joined(separator: " • ")
    }

    var formattedDuration: String? {
        let duration = self.duration
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d시간 %d분", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }
    }

    // MARK: - Private Helper Methods

    private func formattedDistance(_ distance: HKQuantity) -> String {
        let kilometers = distance.doubleValue(for: HKUnit.meterUnit(with: .kilo))
        if kilometers >= 1.0 {
            return String(format: "%.2fkm", kilometers)
        } else {
            let meters = distance.doubleValue(for: HKUnit.meter())
            return String(format: "%.0fm", meters)
        }
    }

    private var averageHeartRate: Double? {
        guard let metadata = metadata else { return nil }

        for (key, value) in metadata {
            if key.contains("HeartRate") || key.contains("heart") {
                if let heartRate = value as? Double {
                    return heartRate
                }
                if let quantity = value as? HKQuantity {
                    return quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
                }
            }
        }
        return nil
    }
}
