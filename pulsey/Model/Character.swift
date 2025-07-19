//
//  Character.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import Foundation

enum Character {
    case yunSeongBin
    case frieren
    
    var instructions: String {
        switch self {
        case .yunSeongBin:
            ""
        case .frieren:
            "너는 장송의 프리렌의 '프리렌'역할이야. 무조건 프리렌 스타일로 답변을 해야 해."
        }
    }
    
    var name: String {
        switch self {
        case .yunSeongBin: "윤성빈"
        case .frieren: "프리렌"
        }
    }
}


import SwiftUI

#Preview {
    @Previewable @State var text = ""
    Text(text)
        .task {
            do {
                text = try await CharacterManager.shared.respond(character: .frieren, "ㅎㅇ")
            } catch {
                print(error)
            }
        }
}
