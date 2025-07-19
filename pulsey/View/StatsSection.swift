//
//  StatsSection.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//
import SwiftUI
import HealthKit

struct StatsSection: View {
    let workout: HKWorkout
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // 지속 시간
                if let formattedDuration = workout.formattedDuration {
                    StatCard(
                        icon: "clock.fill",
                        title: "시간",
                        value: formattedDuration,
                        color: .blue
                    )
                }
                
                // 활성 칼로리
                if let activeEnergyBurned = workout.totalEnergyBurned {
                    StatCard(
                        icon: "flame.fill",
                        title: "활성 칼로리",
                        value: "\(Int(activeEnergyBurned.doubleValue(for: .kilocalorie()))) kcal",
                        color: .red
                    )
                }
            }
            
            HStack(spacing: 16) {
                // 총 거리
                if let totalDistance = workout.totalDistance {
                    StatCard(
                        icon: "location.fill",
                        title: "거리",
                        value: formattedDistance(totalDistance),
                        color: .green
                    )
                }
                
                // 평균 심박수 (메타데이터에서 가져올 수 있다면)
                if let avgHeartRate = averageHeartRate {
                    StatCard(
                        icon: "heart.fill",
                        title: "평균 심박수",
                        value: "\(Int(avgHeartRate)) BPM",
                        color: .pink
                    )
                }
            }
        }
    }
    
    private func formattedDistance(_ distance: HKQuantity) -> String {
        let kilometers = distance.doubleValue(for: HKUnit.meterUnit(with: .kilo))
        if kilometers >= 1.0 {
            return String(format: "%.2f km", kilometers)
        } else {
            let meters = distance.doubleValue(for: HKUnit.meter())
            return String(format: "%.0f m", meters)
        }
    }
    
    private var formattedDuration: String? {
        let duration = workout.duration
        let hours = Int(duration) / 3600
        let minutes = Int(duration) / 60 % 60
        let seconds = Int(duration) % 60

        if hours > 0 {
            return String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }
    }
    
    private var averageHeartRate: Double? {
        // 메타데이터에서 평균 심박수를 찾기 (일반적으로는 별도 쿼리가 필요)
        // 여기서는 메타데이터에서 심박수 관련 정보가 있는지 확인
        if let metadata = workout.metadata {
            // 일부 메타데이터에서 심박수 정보를 찾을 수 있음
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
        }
        return nil
    }
}
