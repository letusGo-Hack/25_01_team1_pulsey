//
//  RoutineManager.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import FoundationModels
import Observation

@Observable
@MainActor
final class RoutinePlanner {
    private(set) var suggestionWorkout : Workout.PartiallyGenerated?
    private let session : LanguageModelSession
    let model = SystemLanguageModel.default
    let workout : Workout
    
    init(workout : Workout) {
        self.workout = workout
        self.session = LanguageModelSession(instructions: Instructions {
            "너의 목표는 사용자가 선택한 운동 카테고리와 운동 시간대(요일, 운동시간)에 따라 추천 운동 루틴을 만드는거야"
            """
            참고하고자 하는 레퍼런스는 사용자가 선택한 운동 카테고리인 \(workout.sportsType)과 운동 시간대 중 선택한 요일 \(workout.selectDays)과 운동시간 \(workout.workoutTime)이 있어.
            운동 시간은 30분 단위야.
            """
        })
    }
    
    func suggestWorkout() async throws {
        let stream = session.streamResponse(
            generating: Workout.self,
            options: GenerationOptions(sampling: .greedy),
            includeSchemaInPrompt: false
        ) {
            "오늘의 운동 루틴을 추천해드릴게요 !"
            
            "추천 운동 루틴은 다음과 같아요 !"
            Workout.exampleWorkouts
        }

        for try await partialResponse in stream {
            suggestionWorkout = partialResponse
        }
    }
}

extension Workout {
    static let exampleWorkouts = Workout(sportsType: [.init(id: 0, name: "러닝", imageName: "figure.run")], selectDays: ["월요일", "수요일", "금요일"], workoutTime: 2)
}
