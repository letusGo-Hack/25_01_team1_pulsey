//
//  SelectSportsView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct SelectSportsView: View {
    @Binding var selectedSports: Set<Int>
    @Environment(\.dismiss) private var dismiss
    
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
        VStack(spacing: 20) {
            // 헤더
            VStack(alignment: .leading, spacing: 8) {
                Text("운동 종류 선택")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("하고 싶은 운동을 여러 개 선택해주세요")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            // 전체선택 버튼
            HStack {
                Spacer()
                Button(action: {
                    if selectedSports.count == sports.count {
                        // 모든 운동이 선택되어 있으면 전체 해제
                        selectedSports.removeAll()
                    } else {
                        // 모든 운동 선택
                        selectedSports = Set(sports.map { $0.id })
                    }
                }) {
                    Text(selectedSports.count == sports.count ? "전체해제" : "전체선택")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.blue.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal)
            
            // 운동 종류 그리드
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(100), spacing: 12), count: 3), spacing: 16) {
                    ForEach(sports) { sport in
                        SportCard(
                            sport: sport,
                            isSelected: selectedSports.contains(sport.id)
                        ) {
                            if selectedSports.contains(sport.id) {
                                selectedSports.remove(sport.id)
                            } else {
                                selectedSports.insert(sport.id)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // 선택 완료 버튼
            Button(action: {
                let selectedSportNames = sports.filter { selectedSports.contains($0.id) }.map { $0.name }
                print("선택된 운동: \(selectedSportNames)")
                dismiss()
            }) {
                Text("운동 종류 선택 완료")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedSports.isEmpty ? Color.gray : Color.blue)
                    )
            }
            .disabled(selectedSports.isEmpty)
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct SportCard: View {
    let sport: Sport
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: sport.imageName)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue : Color.blue.opacity(0.1))
                    )
                
                Text(sport.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .blue : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SelectSportsView(selectedSports: .constant([]))
}
