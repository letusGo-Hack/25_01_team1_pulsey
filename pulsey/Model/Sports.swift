//
//  Sports.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation
import FoundationModels

@Generable
struct Sport : Equatable, Hashable, Identifiable {
    let id : Int
    @Guide(description: "운동 이름")
    let name : String
    let imageName : String
}
