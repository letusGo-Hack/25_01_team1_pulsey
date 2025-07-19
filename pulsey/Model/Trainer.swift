//
//  Trainer.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation

struct Trainer: Identifiable {
    let id: Int
    let name: String
    let imageName: String
    // 예시 말투?
    let motivation: String
}

extension Trainer {
    static let allTrainers: [Trainer] = [
        Trainer(id: 0, name: "장원영", imageName: "wonyoung_character", motivation: "오늘 하루도 파이팅! 작은 진전이 큰 변화를 만듭니다."),
        Trainer(id: 1, name: "윤성빈", imageName: "sungbin_character", motivation: "당신의 목표를 향해 한 걸음씩 나아가세요. 함께 해요!"),
        Trainer(id: 2, name: "프리렌", imageName: "frieren_character", motivation: "꾸준함이 최고의 무기입니다. 오늘도 최선을 다해봐요!"),
        Trainer(id: 3, name: "기가채드", imageName: "chad_character", motivation: "자신을 믿으세요. 당신은 생각보다 훨씬 강합니다!")
    ]
}

extension [Trainer] {
    func findTrainer(id: Int) -> Trainer? {
        self.first { $0.id == id }
    }
}
