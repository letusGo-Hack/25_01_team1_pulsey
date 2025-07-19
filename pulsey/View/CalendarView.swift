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
    @State private var clickedWorkout: HKWorkout?
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                Divider()
                if let selectedWorkout {
                    VStack(spacing: 0) {
                        Button {
                            clickedWorkout = selectedWorkout
                        } label: {
                            HStack {
                                Text("운동 정보")
                                    .foregroundStyle(.black)
                                    .bold()
                                    .font(.title3)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 14, height: 14)
                                    .opacity(0.4)
                            }
                            .padding(.horizontal, 14)
                        }
                        WorkoutDetailView(workout: selectedWorkout)
                    }
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                }
            }
        }
        .navigationDestination(item: $clickedWorkout) { workout in
            WorkoutDetailCoachingView(workout: workout) {
                clickedWorkout = nil
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
    NavigationStack {
        CalendarView()
    }
}
