//
//  ContentView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct UserInfoView: View {
    @State private var nickname : String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var gender: String = "남성"
    @State private var age: String = ""
    @State private var selectedDays: Set<String> = []
    @State private var workoutDuration: Int = 1 // 30분 단위로 1 = 30분, 2 = 1시간, 3 = 1시간 30분...
    @State private var selectedSports: Set<Int> = []
    @State private var showingSportsSelection = false

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
    
    var body: some View {
        //        NavigationView {
        //
        //            .navigationTitle("개인 정보 입력")
        //        }
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
                    Text("cm")
                }
                
                HStack {
                    Text("체중")
                    Spacer()
                    TextField("65", text: $weight)
                        .multilineTextAlignment(.trailing)
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
                    Text("세")
                }
            } header: {
                Text("개인 정보")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("운동 요일 선택")
                            .font(.headline)
                            .padding(.bottom, 4)
                        Spacer()
                        Button(action: {
                            if selectedDays.count == weekDays.count {
                                // 모든 요일이 선택되어 있으면 전체 해제
                                selectedDays.removeAll()
                            } else {
                                // 모든 요일 선택
                                selectedDays = Set(weekDays)
                            }
                        }) {
                            Text(selectedDays.count == weekDays.count ? "전체해제" : "전체선택")
                                .font(.caption)
                                .foregroundStyle(Color(.lightGray))
                        }
                    }
                    
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
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
                                            .font(.system(size: 20))
                                        Text(day)
                                            .font(.caption)
                                            .foregroundColor(selectedDays.contains(day) ? .blue : .primary)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedDays.contains(day) ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                }
                .padding(.vertical, 8)
                
                HStack {
                    Text("운동시간")
                        .font(.headline)
                        .padding(.bottom, 4)
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
                    .frame(width: 120)
                }
                
                HStack {
                    Text("자주 하는 운동")
                        .font(.headline)
                        .padding(.bottom, 4)
                    Spacer()
                    Button(action: {
                        showingSportsSelection = true
                    }) {
                        Text(selectedSports.isEmpty ? "선택하기" : "\(selectedSports.count)개 선택됨")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            } header: {
                Text("운동 스케줄")
                
            }
            
            Section {
                Button(action: {
                    // 여기에 저장 로직을 추가할 수 있습니다
                    print("닉네임: \(nickname)")
                    print("키: \(height)cm, 체중: \(weight)kg, 성별: \(gender), 나이: \(age)세")
                    print("선택된 요일: \(selectedDays)")
                    
                    let hours = workoutDuration / 2
                    let minutes = (workoutDuration % 2) * 30
                    let durationText = hours > 0 && minutes > 0 ? "\(hours)시간 \(minutes)분" :
                    hours > 0 ? "\(hours)시간" : "\(minutes)분"
                    print("운동시간: \(durationText)")
                    
                    if !selectedSports.isEmpty {
                        let selectedSportNames = sports.filter { selectedSports.contains($0.id) }.map { $0.name }
                        print("자주 하는 운동: \(selectedSportNames)")
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("저장")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(height.isEmpty || weight.isEmpty || age.isEmpty)
            }
            
            if !height.isEmpty && !weight.isEmpty && !age.isEmpty {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        if !nickname.isEmpty {
                            Text("닉네임: \(nickname)")
                        }
                        Text("키: \(height)cm")
                        Text("체중: \(weight)kg")
                        Text("성별: \(gender)")
                        Text("나이: \(age)세")
                        if !selectedDays.isEmpty {
                            Text("운동 요일: \(selectedDays.sorted().joined(separator: ", "))")
                        }
                        
                        let hours = workoutDuration / 2
                        let minutes = (workoutDuration % 2) * 30
                        let durationText = hours > 0 && minutes > 0 ? "\(hours)시간 \(minutes)분" :
                        hours > 0 ? "\(hours)시간" : "\(minutes)분"
                        Text("운동시간: \(durationText)")
                        
                        if !selectedSports.isEmpty {
                            let selectedSportNames = sports.filter { selectedSports.contains($0.id) }.map { $0.name }
                            Text("자주 하는 운동: \(selectedSportNames.joined(separator: ", "))")
                        }
                    }
                    .font(.body)
                } header: {
                    Text("입력된 정보")
                }
            }
        }
        .sheet(isPresented: $showingSportsSelection) {
            SelectSportsView(selectedSports: $selectedSports)
        }
    }
}

#Preview {
    UserInfoView()
}
