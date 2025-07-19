//
//  CharacterManager.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import FoundationModels

private extension Character {
    var languageModelSession: LanguageModelSession {
        LanguageModelSession(instructions: self.instructions)
    }
}

class CharacterManager {
    let model = SystemLanguageModel.default
    static let shared = CharacterManager()
    
    private init() {}
    
    func respond(character: Character, _ prompt: String) async throws -> String {
        let response = try await character.languageModelSession.respond(to: prompt)
        return response.content
    }
    
    func respondForAlarm(character: Character) async throws -> String {
        let response = try await character.languageModelSession.respond(to: "동기부여 알림 메세지를 10~20 글자로 만들어줘.")
        return response.content
    }
    
    func respondWithHealthData(health: String, character: Character) async throws -> String {
        let response = try await character.languageModelSession.respond(to: "아래 헬스 정보를 요약해줘.\n\(health)")
        
        return response.content
    }
}
