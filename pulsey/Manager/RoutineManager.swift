//
//  RoutineManager.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import FoundationModels
import Observation

//let sports = [
//    Sport(id: 0, name: "러닝", imageName: "figure.run"),
//    Sport(id: 1, name: "헬스", imageName: "dumbbell.fill"),
//    Sport(id: 2, name: "요가", imageName: "figure.mind.and.body"),
//    Sport(id: 3, name: "수영", imageName: "figure.pool.swim"),
//    Sport(id: 4, name: "자전거", imageName: "bicycle"),
//    Sport(id: 5, name: "등산", imageName: "mountain.2.fill"),
//    Sport(id: 6, name: "테니스", imageName: "tennis.racket"),
//    Sport(id: 7, name: "축구", imageName: "soccerball"),
//    Sport(id: 8, name: "농구", imageName: "basketball.fill"),
//    Sport(id: 9, name: "배드민턴", imageName: "figure.badminton"),
//    Sport(id: 10, name: "복싱", imageName: "figure.boxing"),
//    Sport(id: 11, name: "필라테스", imageName: "figure.core.training")
//]

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
