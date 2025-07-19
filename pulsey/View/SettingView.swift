//
//  SettingView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import Foundation
import SwiftUI

struct SettingView: View {
    @AppStorage("user_workout_data") private var workoutData: Data = Data()
    @State private var nickname: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var gender: String = "남성"
    @State private var age: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var workoutDuration: Int = 1
    @State private var selectedSports: Set<Int> = []
    @State private var showingSportsSelection = false
    @State private var showingProfileEdit = false
    @State private var showingWorkoutEdit = false

    let genderOptions = ["남성", "여성"]
    let weekDays = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]

    let sports = [
        Sport(id: 0, name: "러닝", imageName: "figure.run"),
        Sport(id: 1, name: "헬스", imageName: "dumbbell.fill"),
        Sport(id: 2, name: "요가", imageName: "figure.mind.and.body"),
        Sport(id: 3, name: "수영", imageName: "figure.pool.swim"),
        Sport(id: 4, name: "자전거", imageName: "bicycle"),
        Sport(id: 5, name: "등산", imageName: "mountain.2.fill"),
        Sport(id: 6, name: "테니스", imageName: "tennis.racket"),
        Sport(id: 7, name: "축구", imageName: "soccerball"),
        Sport(id: 8, name: "농구", imageName: "basketball.fill"),
        Sport(id: 9, name: "배드민턴", imageName: "figure.badminton"),
        Sport(id: 10, name: "복싱", imageName: "figure.boxing"),
        Sport(id: 11, name: "필라테스", imageName: "figure.core.training")
    ]

    // Workout 데이터를 저장하는 함수
    private func saveWorkoutData() {
        let selectedSportObjects = sports.filter { selectedSports.contains($0.id) }
        let workout = Workout(
            sportsType: selectedSportObjects,
            selectDays: Array(selectedDays),
            workoutTime: workoutDuration
        )

        if let data = try? JSONEncoder().encode(workout) {
            workoutData = data
        }
    }

    // Workout 데이터를 로드하는 함수
    private func loadWorkoutData() {
        if let workout = try? JSONDecoder().decode(Workout.self, from: workoutData) {
            selectedDays = Set(workout.selectDays)
            workoutDuration = workout.workoutTime
            selectedSports = Set(workout.sportsType.map { $0.id })
        }
    }

    // 운동 시간을 텍스트로 변환하는 함수
    private func getWorkoutDurationText() -> String {
        let hours = workoutDuration / 2
        let minutes = (workoutDuration % 2) * 30
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(minutes)분"
        }
    }

    // 선택된 운동 이름들을 가져오는 함수
    private func getSelectedSportsNames() -> [String] {
        return sports.filter { selectedSports.contains($0.id) }.map { $0.name }
    }

    var body: some View {
        NavigationView {
            List {
                // 프로필 정보 섹션
                Section {
                    NavigationLink(destination: ProfileEditView(
                        nickname: $nickname,
                        height: $height,
                        weight: $weight,
                        gender: $gender,
                        age: $age
                    )) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("프로필 정보")
                                    .font(.headline)
                                Text(nickname.isEmpty ? "닉네임을 설정해주세요" : nickname)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("개인 정보")
                }

                // 운동 설정 섹션
                Section {
                    NavigationLink(destination: WorkoutSettingView(
                        selectedDays: $selectedDays,
                        workoutDuration: $workoutDuration,
                        selectedSports: $selectedSports,
                        weekDays: weekDays,
                        sports: sports
                    )) {
                        HStack {
                            Image(systemName: "dumbbell.fill")
                                .foregroundColor(.green)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("운동 설정")
                                    .font(.headline)
                                Text("\(selectedDays.count)일, \(getWorkoutDurationText())")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("운동 스케줄")
                }

                // 트레이너 선택 섹션 (새로 추가)
                Section {
                    NavigationLink(destination: SelectCharacterView()) {
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(.purple)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("트레이너 선택")
                                    .font(.headline)
                                Text("나만의 AI 트레이너를 선택하세요")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        .padding(.vertical, 4)
                    }
                } header: {
                    Text("트레이너")
                }

                // 현재 설정 미리보기 섹션
                if !height.isEmpty || !weight.isEmpty || !age.isEmpty || !selectedDays.isEmpty {
                    Section {
                        VStack(alignment: .leading, spacing: 8) {
                            if !nickname.isEmpty {
                                HStack {
                                    Text("닉네임:")
                                        .fontWeight(.medium)
                                    Text(nickname)
                                }
                            }

                            if !height.isEmpty {
                                HStack {
                                    Text("키:")
                                        .fontWeight(.medium)
                                    Text("\(height)cm")
                                }
                            }

                            if !weight.isEmpty {
                                HStack {
                                    Text("체중:")
                                        .fontWeight(.medium)
                                    Text("\(weight)kg")
                                }
                            }

                            if !age.isEmpty {
                                HStack {
                                    Text("나이:")
                                        .fontWeight(.medium)
                                    Text("\(age)세")
                                }
                            }

                            HStack {
                                Text("성별:")
                                    .fontWeight(.medium)
                                Text(gender)
                            }

                            if !selectedDays.isEmpty {
                                HStack {
                                    Text("운동 요일:")
                                        .fontWeight(.medium)
                                    Text(selectedDays.sorted().joined(separator: ", "))
                                }
                            }

                            HStack {
                                Text("운동 시간:")
                                    .fontWeight(.medium)
                                Text(getWorkoutDurationText())
                            }

                            if !selectedSports.isEmpty {
                                HStack {
                                    Text("선택된 운동:")
                                        .fontWeight(.medium)
                                    Text(getSelectedSportsNames().joined(separator: ", "))
                                }
                            }
                        }
                        .font(.subheadline)
                    } header: {
                        Text("현재 설정")
                    }
                }

                // 앱 정보 섹션
                Section {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("앱 버전")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.orange)
                        Text("도움말")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }

                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.green)
                        Text("문의하기")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                } header: {
                    Text("앱 정보")
                }
            }
            .navigationTitle("설정")
            .onAppear {
                loadWorkoutData()
            }
            .onChange(of: selectedSports) { _ in
                saveWorkoutData()
            }
        }
    }
}

// 프로필 편집 뷰
struct ProfileEditView: View {
    @Binding var nickname: String
    @Binding var height: String
    @Binding var weight: String
    @Binding var gender: String
    @Binding var age: String

    let genderOptions = ["남성", "여성"]

    var body: some View {
        Form {
            Section {
                HStack {
                    Text("닉네임")
                    Spacer()
                    TextField("Pulsey", text: $nickname)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("키")
                    Spacer()
                    TextField("175", text: $height)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("cm")
                }

                HStack {
                    Text("체중")
                    Spacer()
                    TextField("65", text: $weight)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("kg")
                }

                HStack {
                    Text("성별")
                    Spacer()
                    Picker("성별", selection: $gender) {
                        ForEach(genderOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 120)
                }

                HStack {
                    Text("나이")
                    Spacer()
                    TextField("20", text: $age)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                    Text("세")
                }
            } header: {
                Text("개인 정보")
            }
        }
        .navigationTitle("프로필 편집")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 운동 설정 뷰
struct WorkoutSettingView: View {
    @Binding var selectedDays: Set<String>
    @Binding var workoutDuration: Int
    @Binding var selectedSports: Set<Int>
    let weekDays: [String]
    let sports: [Sport]

    @State private var showingSportsSelection = false

    private func getWorkoutDurationText() -> String {
        let hours = workoutDuration / 2
        let minutes = (workoutDuration % 2) * 30
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(minutes)분"
        }
    }

    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("운동 요일 선택")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            if selectedDays.count == weekDays.count {
                                selectedDays.removeAll()
                            } else {
                                selectedDays = Set(weekDays)
                            }
                        }) {
                            Text(selectedDays.count == weekDays.count ? "전체해제" : "전체선택")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(weekDays, id: \.self) { day in
                            Button(action: {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: selectedDays.contains(day) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedDays.contains(day) ? .blue : .gray)
                                    Text(day)
                                        .font(.caption)
                                        .foregroundColor(selectedDays.contains(day) ? .blue : .primary)
                                }
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(selectedDays.contains(day) ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            } header: {
                Text("운동 요일")
            }

            Section {
                HStack {
                    Text("운동 시간")
                    Spacer()
                    Picker("", selection: $workoutDuration) {
                        ForEach(1...8, id: \.self) { duration in
                            let hours = duration / 2
                            let minutes = (duration % 2) * 30
                            if hours > 0 && minutes > 0 {
                                Text("\(hours)시간 \(minutes)분").tag(duration)
                            } else if hours > 0 {
                                Text("\(hours)시간").tag(duration)
                            } else {
                                Text("\(minutes)분").tag(duration)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                }
            } header: {
                Text("운동 시간")
            }

            Section {
                HStack {
                    Text("자주 하는 운동")
                    Spacer()
                    Button(action: {
                        showingSportsSelection = true
                    }) {
                        Text(selectedSports.isEmpty ? "선택하기" : "\(selectedSports.count)개 선택됨")
                            .foregroundColor(.blue)
                    }
                }
            } header: {
                Text("운동 종류")
            }
        }
        .navigationTitle("운동 설정")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSportsSelection) {
            SelectSportsView(selectedSports: $selectedSports)
        }
    }
}

#Preview {
    SettingView()
}
