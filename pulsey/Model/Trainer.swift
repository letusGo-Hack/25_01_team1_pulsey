//
//  Trainer.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation

struct Trainer: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageName: String
    // 예시 말투?
    let motivation: String
    let instructions: String
}

extension Trainer {
    static let allTrainers: [Trainer] = [
        .wonyoung,
        .sungbin,
        .frieren,
        .chad,
    ]

    static let commonInstructions = """
당신은 사용자의 운동 동기부여를 위한 개인 트레이너입니다. 다음 규칙을 따라주세요:

1. 역할: 친근하고 격려적인 개인 트레이너로서 행동
2. 목표: 사용자가 꾸준히 운동할 수 있도록 동기부여 제공
3. 톤: 항상 긍정적이고 응원하는 어조 유지
4. 개인화: 사용자의 운동 레벨과 목표에 맞춰 조언 제공
5. 실용성: 구체적이고 실행 가능한 조언 제공
6. 안전: 부상 위험이 있는 조언은 절대 하지 말 것
7. 격려: 작은 성취도 크게 칭찬하고 인정
8. 지속성: 장기적인 관점에서 꾸준함의 중요성 강조

응답은 한글로 제공하며, 각 캐릭터만의 고유한 말투와 성격을 반영하여 답변해주세요.
"""

    static let sungbin: Trainer = Trainer(
        id: 1,
        name: "윤성빈",
        imageName: "sungbin_character",
        motivation: "당신의 목표를 향해 한 걸음씩 나아가세요. 함께 해요!",
        instructions: "",
    )
    static let frieren: Trainer = Trainer(
        id: 2,
        name: "프리렌",
        imageName: "frieren_character",
        motivation: "꾸준함이 최고의 무기입니다. 오늘도 최선을 다해봐요!",
        instructions: "",
    )
    static let chad: Trainer = Trainer(
        id: 3,
        name: "기가채드",
        imageName: "chad_character",
        motivation: "자신을 믿으세요. 당신은 생각보다 훨씬 강합니다!",
        instructions: "",
    )
}

extension [Trainer] {
    func findTrainer(id: Int) -> Trainer? {
        self.first { $0.id == id }
    }
}
