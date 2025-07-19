//
//  WorkoutDetailCoachingView.swift
//  pulsey
//
//  Created by Mason Kim on 7/19/25.
//

import SwiftUI
import HealthKit
import FoundationModels

struct WorkoutDetailCoachingView: View {
    let workout: HKWorkout
    let onDismiss: () -> Void

    @AppStorage("selectedTrainer") private var selectedTrainer: Int = 0
    var trainer: Trainer? {
        Trainer.allTrainers.first(where: { $0.id == selectedTrainer })
    }
    @State private var coachingMessage: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let trainer {
                        TrainerCard(trainer: trainer, isSelected: false, onTap: {})
                    }

                    if coachingMessage.isEmpty == false {
                        MessageView(message: coachingMessage)
                    }

                    WorkoutDetailView(workout: workout)
                }
            }
            .navigationTitle("운동 요약")
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        onDismiss()
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .task {
            guard let trainer else { return }
            do {
                let stream = TrainerManager.shared.respondStreamWithHealthData(workout: workout, trainer: trainer)
                for try await response in stream {
                    self.coachingMessage = response
                }
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
