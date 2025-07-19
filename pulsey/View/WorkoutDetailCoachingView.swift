//
//  WorkoutDetailCoachingView.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import SwiftUI
import HealthKit

struct WorkoutDetailCoachingView: View {
    let workout: HKWorkout

    @AppStorage("selectedTrainer") private var selectedTrainer: Int = 0
    var trainer: Trainer? {
        Trainer.allTrainers.first(where: { $0.id == selectedTrainer })
    }
    @State private var coachingMessage: String = ""
    @State private var isPlaying: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let trainer {
                        TrainerCard(trainer: trainer, isSelected: false, onTap: {})
                    }

                    MessageView(isPlaying: $isPlaying, message: coachingMessage)

                    WorkoutDetailView(workout: workout)
                }
            }
            .navigationTitle("운동 요약")
            .background(Color(.systemBackground))
        }
        .task {
            guard let trainer else { return }
            do {
                print(workout.description)
                let response = try await TrainerManager.shared.respondWithHealthData(workout: workout, trainer: trainer)
                self.coachingMessage = response
            } catch {
                print(error)
                self.coachingMessage = "코칭 메시지를 불러오지 못했습니다."
            }
        }
    }
}

#Preview {
    WorkoutDetailCoachingView(workout: [HKWorkout].mock.randomElement()!)
}
