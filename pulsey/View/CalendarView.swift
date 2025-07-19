//
//  DashboardView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI
import HealthKit

struct CalendarView: View {
    @State private var selectedMonth = Date.now
    @State private var selectedDate = Date.now
    @State private var workouts: [HKWorkout]?
    private var selectedWorkout: HKWorkout? {
        workouts?.first {
            $0.startDate.equals(selectedDate, components: [.day])
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                Divider()
                if let selectedWorkout {
                    StatsSection(workout: selectedWorkout)
                        .padding(.horizontal, 12)
                }
            }
        }
        .task {
            do {
                let workouts = try await HealthKitManager.shared.fetchWorkouts()
                self.workouts = workouts
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    CalendarView()
}
