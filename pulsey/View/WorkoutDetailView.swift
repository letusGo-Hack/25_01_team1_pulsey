//
//  WorkoutDetailView.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import SwiftUI
import HealthKit

struct WorkoutDetailView: View {
    let workout: HKWorkout

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 헤더 섹션
                headerSection

                // 주요 통계 섹션
                mainStatsSection
            }
            .padding()
        }
        .navigationTitle("운동 상세")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // 운동 아이콘
            Image(systemName: workoutIcon)
                .font(.system(size: 50))
                .foregroundColor(.orange)

            // 운동 타입
            Text(workout.workoutActivityType.koreanName)
                .font(.title2)
                .fontWeight(.semibold)

            // 운동 날짜
            Text(formattedDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .glassEffect()
    }

    // MARK: - Main Stats Section
    private var mainStatsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // 지속 시간
                StatCard(
                    icon: "clock.fill",
                    title: "시간",
                    value: formattedDuration,
                    color: .blue
                )

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
}

// MARK: - Supporting Views
struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .glassEffect()
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Extensions
extension WorkoutDetailView {
    private var workoutIcon: String {
        switch workout.workoutActivityType {
        case .running:
            return "figure.run"
        case .walking:
            return "figure.walk"
        case .cycling:
            return "bicycle"
        case .swimming:
            return "figure.pool.swim"
        case .yoga:
            return "figure.yoga"
        case .functionalStrengthTraining:
            return "dumbbell.fill"
        case .coreTraining:
            return "figure.core.training"
        case .flexibility:
            return "figure.flexibility"
        default:
            return "figure.workout"
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        return formatter.string(from: workout.startDate)
    }

    private var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: workout.startDate)
    }

    private var formattedEndTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: workout.endDate)
    }

    private var formattedDuration: String {
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

    private func formattedDistance(_ distance: HKQuantity) -> String {
        let kilometers = distance.doubleValue(for: HKUnit.meterUnit(with: .kilo))
        if kilometers >= 1.0 {
            return String(format: "%.2f km", kilometers)
        } else {
            let meters = distance.doubleValue(for: HKUnit.meter())
            return String(format: "%.0f m", meters)
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

    private func localizedMetadataKey(_ key: String) -> String {
        switch key {
        case HKMetadataKeyWeatherCondition:
            return "날씨 상태"
        case HKMetadataKeyWeatherTemperature:
            return "온도"
        case HKMetadataKeyWeatherHumidity:
            return "습도"
        case HKMetadataKeyElevationAscended:
            return "상승 고도"
        case HKMetadataKeyElevationDescended:
            return "하강 고도"
        case HKMetadataKeyIndoorWorkout:
            return "실내 운동"
        default:
            return key.replacingOccurrences(of: "HKMetadataKey", with: "")
        }
    }
}

// MARK: - Preview
struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutDetailView(workout: sampleWorkout)
        }
    }

    static var sampleWorkout: HKWorkout {
        let startDate = Date().addingTimeInterval(-3600)
        let endDate = Date()

        return HKWorkout(
            activityType: .running,
            start: startDate,
            end: endDate,
            duration: 3600,
            totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: 350),
            totalDistance: HKQuantity(unit: HKUnit.meterUnit(with: .kilo), doubleValue: 5.2),
            metadata: [
                HKMetadataKeyWeatherTemperature: HKQuantity(unit: HKUnit.degreeCelsius(), doubleValue: 22)
            ]
        )
    }
}
