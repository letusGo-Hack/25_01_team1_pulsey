//
//  UserRoutineView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct UserRoutineView: View {
    @AppStorage("user_workout_data") private var workoutData: Data = Data()
    @State private var isLoading = true
    @State private var showingRecommendation = false
    @State private var timeElapsed: TimeInterval = 0
    @State private var timer: Timer?
    @State private var recommendedWorkouts: [RecommendedWorkout] = []
    @State private var isGeneratingRecommendations = false
    
    // 실제 AppStorage에서 데이터를 가져오도록 수정
    private var selectedWorkout: Workout? {
                guard !workoutData.isEmpty else { return nil }
                return try? JSONDecoder().decode(Workout.self, from: workoutData)
    }
    
    let weekDays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("운동 루틴을 불러오는 중...")
                        .onAppear {
                            loadWorkoutData()
                        }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // 현재 설정된 루틴 표시
                            if let workout = selectedWorkout {
                                CurrentRoutineCard(workout: workout, weekDays: weekDays)
                            } else {
                                CurrentRoutineCard(weekDays: weekDays)
                            }
                            
                            // 추천 운동 섹션
                            RecommendationSection(
                                showingRecommendation: $showingRecommendation,
                                timeElapsed: timeElapsed,
                                recommendedWorkouts: recommendedWorkouts,
                                isGeneratingRecommendations: isGeneratingRecommendations
                            )
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("내 운동 루틴")
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func generateRecommendations() {
        isGeneratingRecommendations = true
        
        Task {
            do {
                // 현재 사용자의 Workout 데이터 사용
                guard let currentWorkout = selectedWorkout else {
                    await MainActor.run {
                        self.recommendedWorkouts = getDefaultRecommendations()
                        self.isGeneratingRecommendations = false
                    }
                    return
                }
                
                // RoutinePlanner 사용하여 추천 생성
                let routinePlanner = RoutinePlanner(workout: currentWorkout)
                let suggestedWorkout = try await routinePlanner.suggestWorkout()
                
                await MainActor.run {
                    if let suggested = suggestedWorkout {
                        // RoutinePlanner 결과를 RecommendedWorkout으로 변환
                        self.recommendedWorkouts = convertPlannerResultToRecommendations(
                            plannerResult: suggested,
                            originalWorkout: currentWorkout
                        )
                    } else {
                        self.recommendedWorkouts = getDefaultRecommendations()
                    }
                    self.isGeneratingRecommendations = false
                }
                
            } catch {
                print("RoutinePlanner 오류: \(error)")
                await MainActor.run {
                    self.recommendedWorkouts = getDefaultRecommendations()
                    self.isGeneratingRecommendations = false
                }
            }
        }
    }
    
    // RoutinePlanner 결과를 RecommendedWorkout으로 변환하는 함수
    private func convertPlannerResultToRecommendations(plannerResult: Workout.PartiallyGenerated, originalWorkout: Workout) -> [RecommendedWorkout] {
        var recommendations: [RecommendedWorkout] = []
        
        // 첫 번째 추천: RoutinePlanner의 AI 추천 결과
        if let suggestedSports = plannerResult.sportsType {
            let sportsNames = suggestedSports.map { $0.name }
            let suggestedDuration = plannerResult.workoutTime ?? originalWorkout.workoutTime
            let suggestedDays = plannerResult.selectDays ?? originalWorkout.selectDays
            
            recommendations.append(RecommendedWorkout(
                sports: sportsNames as! [String],
                duration: suggestedDuration * 30,
                days: suggestedDays,
                reason: "AI가 분석한 개인 맞춤형 운동 루틴"
            ))
        }
        
        // 두 번째 추천: 현재 설정 기반
        let currentSportsNames = originalWorkout.sportsType.map { $0.name }
        recommendations.append(RecommendedWorkout(
            sports: currentSportsNames,
            duration: originalWorkout.workoutTime * 30,
            days: originalWorkout.selectDays,
            reason: "현재 설정을 기반으로 한 안정적인 루틴"
        ))
        
        // 세 번째 추천: 보완 운동
        let complementarySports = getComplementarySports(for: originalWorkout.sportsType)
        recommendations.append(RecommendedWorkout(
            sports: complementarySports,
            duration: originalWorkout.workoutTime * 30,
            days: originalWorkout.selectDays,
            reason: "균형잡힌 운동을 위한 보완 운동 조합"
        ))
        
        return recommendations
    }
    
    private func getComplementarySports(for currentSports: [Sport]) -> [String] {
        let currentSportNames = Set(currentSports.map { $0.name })
        let allSports = [
            "러닝", "헬스", "요가", "수영", "자전거", "복싱", "필라테스", "등산", "테니스"
        ]
        
        let complementary = allSports.filter { !currentSportNames.contains($0) }
        return Array(complementary.prefix(3))
    }
    
    private func getDefaultRecommendations() -> [RecommendedWorkout] {
        return [
            RecommendedWorkout(
                sports: ["러닝", "헬스", "요가"],
                duration: 90,
                days: ["월요일", "수요일", "금요일"],
                reason: "균형잡힌 운동 조합으로 체력 향상에 도움"
            ),
            RecommendedWorkout(
                sports: ["수영", "자전거"],
                duration: 60,
                days: ["화요일", "목요일", "토요일"],
                reason: "관절에 부담이 적은 저강도 운동"
            ),
            RecommendedWorkout(
                sports: ["복싱", "필라테스"],
                duration: 75,
                days: ["월요일", "화요일", "목요일", "금요일"],
                reason: "근력과 유연성을 동시에 향상시키는 운동"
            )
        ]
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeElapsed += 1
            
            // 5분 후에 추천 운동 생성 시작
            if timeElapsed == 3 && recommendedWorkouts.isEmpty {
                generateRecommendations()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func loadWorkoutData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
        }
    }
}


// 현재 루틴 카드
struct CurrentRoutineCard: View {
    let workout: Workout?
    let weekDays: [String]
    
    init(workout: Workout? = nil, weekDays: [String]) {
        self.workout = workout
        self.weekDays = weekDays
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("현재 설정된 루틴")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "person.fill")
                    .foregroundColor(.blue)
            }
            
            if let workout = workout {
                // 실제 데이터 표시
                VStack(alignment: .leading, spacing: 8) {
                    Text("운동 종류")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    if workout.sportsType.isEmpty {
                        Text("설정된 운동이 없습니다")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                            ForEach(workout.sportsType) { sport in
                                HStack {
                                    Image(systemName: sport.imageName)
                                        .foregroundColor(.blue)
                                    Text(sport.name)
                                        .font(.caption)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(6)
                            }
                        }
                    }
                }
                
                // 운동 요일
                VStack(alignment: .leading, spacing: 8) {
                    Text("운동 요일")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        ForEach(weekDays, id: \.self) { day in
                            VStack(spacing: 2) {
                                Image(systemName: workout.selectDays.contains(day) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(workout.selectDays.contains(day) ? .green : .gray)
                                    .font(.system(size: 12))
                                Text(day)
                                    .font(.caption2)
                                    .foregroundColor(workout.selectDays.contains(day) ? .green : .secondary)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                
                // 운동 시간
                VStack(alignment: .leading, spacing: 8) {
                    Text("운동 시간")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    let hours = workout.workoutTime / 2
                    let minutes = (workout.workoutTime % 2) * 30
                    let durationText = hours > 0 && minutes > 0 ? "\(hours)시간 \(minutes)분" :
                    hours > 0 ? "\(hours)시간" : "\(minutes)분"
                    
                    HStack {
                        Image(systemName: "clock.fill")
                            .foregroundColor(.orange)
                        Text(durationText)
                            .fontWeight(.medium)
                        Spacer()
                    }
                }
            } else {
                // 데이터가 없을 때 기본 표시
                Text("운동 루틴이 설정되지 않았습니다")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

// 추천 운동 섹션
struct RecommendationSection: View {
    @Binding var showingRecommendation: Bool
    let timeElapsed: TimeInterval
    let recommendedWorkouts: [RecommendedWorkout]
    let isGeneratingRecommendations: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("추천 운동 루틴")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                
                if timeElapsed > 300 && !recommendedWorkouts.isEmpty {
                    Button(action: {
                        showingRecommendation.toggle()
                    }) {
                        Image(systemName: showingRecommendation ? "chevron.up" : "chevron.down")
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if timeElapsed < 3 {
                VStack(spacing: 12) {
                    ProgressView(value: timeElapsed, total: 300)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    
                    Text("추천 운동을 준비하고 있습니다...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(Int(3 - timeElapsed))초 남음")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(8)
            } else if isGeneratingRecommendations {
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("AI가 개인 맞춤형 운동을 분석하고 있습니다...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Text("잠시만 기다려주세요")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color.blue.opacity(0.05))
                .cornerRadius(8)
            } else if showingRecommendation && !recommendedWorkouts.isEmpty {
                VStack(spacing: 12) {
                    ForEach(recommendedWorkouts.indices, id: \.self) { index in
                        RecommendationCard(workout: recommendedWorkouts[index], rank: index + 1)
                    }
                }
            } else if !recommendedWorkouts.isEmpty {
                Button(action: {
                    showingRecommendation = true
                }) {
                    HStack {
                        Image(systemName: "lightbulb.fill")
                            .foregroundColor(.yellow)
                        Text("AI 추천 운동 보기")
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .padding()
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
}

// 추천 운동 카드
struct RecommendationCard: View {
    let workout: RecommendedWorkout
    let rank: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("추천 \(rank)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(rankColor)
                    .cornerRadius(8)
                
                Spacer()
                
                Text("\(workout.duration)분")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            // 운동 종류
            VStack(alignment: .leading, spacing: 6) {
                Text("운동 종류")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    ForEach(workout.sports, id: \.self) { sport in
                        Text(sport)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(6)
                    }
                }
            }
            
            // 운동 요일
            VStack(alignment: .leading, spacing: 6) {
                Text("운동 요일")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(workout.days.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            
            // 추천 이유
            VStack(alignment: .leading, spacing: 6) {
                Text("추천 이유")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Text(workout.reason)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .italic()
            }
            
            // 적용 버튼
            Button(action: {
                // 여기에 추천 루틴 적용 로직 추가
                print("추천 루틴 \(rank) 적용")
            }) {
                Text("이 루틴 적용하기")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(rankColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private var rankColor: Color {
        switch rank {
        case 1: return .orange
        case 2: return .blue
        case 3: return .green
        default: return .gray
        }
    }
}

// 추천 운동 모델
struct RecommendedWorkout {
    let sports: [String]
    let duration: Int // 분 단위
    let days: [String]
    let reason: String
}

#Preview {
    UserRoutineView()
}
