//
//  CharacterManager.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import Foundation
import FoundationModels
import HealthKit

final class TrainerManager {
    let model = SystemLanguageModel.default
    static let shared = TrainerManager()

    // 세션 캐싱을 위한 딕셔너리 추가
    private var sessions: [Trainer: LanguageModelSession] = [:]

    private init() {}

    // 세션을 가져오거나 생성하는 헬퍼 메서드
    private func getSession(for trainer: Trainer) -> LanguageModelSession {
        if let existingSession = sessions[trainer] {
            return existingSession
        } else {
            let newSession = LanguageModelSession(model: model, instructions: trainer.instructions)
            sessions[trainer] = newSession
            return newSession
        }
    }

    // 모델 가용성 체크 및 에러 메시지 생성
    private func checkModelAvailability() throws {
        guard model.isAvailable else {
            let reason = availabilityDescription(for: model.availability)
            throw TrainerManagerError.modelUnavailable("The language model is not available. Reason: \(reason)")
        }
    }

    func respond(trainer: Trainer, _ prompt: String) async throws -> String {
        try checkModelAvailability()

        let session = getSession(for: trainer)
        let response = try await session.respond(
            to: prompt,
            options: .init(temperature: 0.7)
        )
        return response.content
    }

    func respondForAlarm(trainer: Trainer) async throws -> String {
        try checkModelAvailability()

        let session = getSession(for: trainer)
        let response = try await session.respond(to: "동기부여 알림 메세지를 10~20 글자로 만들어줘.")
        return response.content
    }

    func respondWithHealthData(workout: HKWorkout, trainer: Trainer) async throws -> String {
        try checkModelAvailability()

        let session = getSession(for: trainer)
        let response = try await session.respond(
            to: "아래 운동 정보에 대한 칭찬과 격려의 동기부여 메시지를 제공해줘.\n\(workout.summaryDescription)"
        )
        return response.content
    }

    // 스트리밍 응답을 위한 새로운 메서드 (옵션)
    func streamResponse(trainer: Trainer, _ prompt: String, temperature: Double = 0.7) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    try checkModelAvailability()

                    let session = getSession(for: trainer)
                    let options = GenerationOptions(temperature: temperature)
                    let stream = session.streamResponse(to: prompt, options: options)

                    for try await partialResponse in stream {
                        continuation.yield(partialResponse)
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    // 세션 초기화 메서드
    func resetSession(for trainer: Trainer) {
        sessions.removeValue(forKey: trainer)
    }

    func resetAllSessions() {
        sessions.removeAll()
    }

    // 모델 가용성 설명을 위한 헬퍼 메서드
    private func availabilityDescription(for availability: SystemLanguageModel.Availability) -> String {
        switch availability {
        case .available:
            return "Available"
        case .unavailable(let reason):
            switch reason {
            case .deviceNotEligible:
                return "Device not eligible"
            case .appleIntelligenceNotEnabled:
                return "Apple Intelligence not enabled in Settings"
            case .modelNotReady:
                return "Model assets not downloaded"
            @unknown default:
                return "Unknown reason"
            }
        @unknown default:
            return "Unknown availability"
        }
    }
}

// 커스텀 에러 타입
enum TrainerManagerError: LocalizedError {
    case modelUnavailable(String)

    var errorDescription: String? {
        switch self {
        case .modelUnavailable(let message):
            return message
        }
    }
}
