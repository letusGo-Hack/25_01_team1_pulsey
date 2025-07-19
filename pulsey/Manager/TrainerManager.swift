//
//  CharacterManager.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import FoundationModels

private extension Trainer {
    var languageModelSession: LanguageModelSession {
        let instructions = "너는 캐릭터 '\(self.name)'역할이야. 무조건 \(self.name) 스타일로 답변을 해야 해."
        return LanguageModelSession(instructions: instructions)
    }
}

class TrainerManager {
    let model = SystemLanguageModel.default
    static let shared = TrainerManager()
    
    private init() {}
    
    func respond(trainer: Trainer, _ prompt: String) async throws -> String {
        let response = try await trainer.languageModelSession.respond(to: prompt)
        return response.content
    }
    
    func respondForAlarm(trainer: Trainer) async throws -> String {
        let response = try await trainer.languageModelSession.respond(to: "동기부여 알림 메세지를 10~20 글자로 만들어줘.")
        return response.content
    }
    
    func respondWithHealthData(health: String, trainer: Trainer) async throws -> String {
        let response = try await trainer.languageModelSession.respond(to: "아래 헬스 정보를 요약해줘.\n\(health)")
        
        return response.content
    }
}
