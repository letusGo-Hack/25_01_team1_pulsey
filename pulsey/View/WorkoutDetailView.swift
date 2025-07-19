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
                StatsSection(workout: workout)
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
            HStack {
                // 운동 아이콘
                if let emoji = workout.workoutActivityType.associatedEmoji() {
                    Text(emoji)
                        .font(.largeTitle)
                }

                // 운동 타입
                Text(workout.workoutActivityType.koreanName)
                    .font(.title2)
                    .fontWeight(.semibold)
            }

            // 운동 날짜
            Text(formattedDate)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .glassEffect()
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
