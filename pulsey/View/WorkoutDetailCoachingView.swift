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
    @State private var coachingMessage: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if let trainer = Trainer.allTrainers.first(where: { $0.id == selectedTrainer }) {
                        TrainerCard(trainer: trainer, isSelected: false, onTap: {})
                    }

                    Text("\(coachingMessage)")

                    WorkoutDetailView(workout: workout)
                }
            }
            .navigationTitle("운동 요약")
        }
        .task {
            CharacterManager.shared.respondWithHealthData(health: <#T##String#>, character: <#T##Character#>)
        }
    }
}

#Preview {
    WorkoutDetailCoachingView(workout: [HKWorkout].mock().randomElement()!)
}
