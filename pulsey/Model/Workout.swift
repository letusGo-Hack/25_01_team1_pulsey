//
//  Workout.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation
import FoundationModels

@Generable
struct Workout : Equatable {
    let nickname : String
    let sportsType : Set<Sport>
    let selectDays : Set<String>
    let workoutTime : Int        // 30분 단위로 1 = 30분, 2 = 1시간, 3 = 1시간 30분...
}
