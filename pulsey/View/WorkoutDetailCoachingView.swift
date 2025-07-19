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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let trainer {
                        TrainerCard(trainer: trainer, isSelected: false, onTap: {})
                    }

                    Text("\(coachingMessage)")

                    WorkoutDetailView(workout: workout)
                }
            }
            .navigationTitle("운동 요약")
        }
        .task {
            do {
                let response = try await CharacterManager.shared.respondWithHealthData(
                    health: workout.description,
                    character: .yunSeongBin
                ) // TODO: Trainer 방식으로 변경
                self.coachingMessage = response
            } catch {
                print(error)
                self.coachingMessage = "코칭 메시지를 불러오지 못했습니다."
            }
        }
    }
}

#Preview {
    WorkoutDetailCoachingView(workout: [HKWorkout].mock().randomElement()!)
}
