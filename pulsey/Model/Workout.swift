//
//  Workout.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation
import FoundationModels

@Generable
struct Workout : Equatable, Codable {
    @Guide(description: "선택한 운동 종류")
    let sportsType : [Sport]
    @Guide(description: "운동하고자 하는 요일")
    let selectDays : [String]
    let workoutTime : Int        // 30분 단위로 1 = 30분, 2 = 1시간, 3 = 1시간 30분...
}
