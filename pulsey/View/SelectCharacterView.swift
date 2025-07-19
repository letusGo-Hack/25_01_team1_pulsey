//
//  SelectCharacterView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI


struct SelectCharacterView: View {
    @State private var selectedTrainer: Int = 0
    
    let trainers = [
        Trainer(id: 0, name: "장원영", imageName: "wonyoung_character", motivation: "오늘 하루도 파이팅! 작은 진전이 큰 변화를 만듭니다."),
        Trainer(id: 1, name: "윤성빈", imageName: "sungbin_character", motivation: "당신의 목표를 향해 한 걸음씩 나아가세요. 함께 해요!"),
        Trainer(id: 2, name: "프리렌", imageName: "frieren_character", motivation: "꾸준함이 최고의 무기입니다. 오늘도 최선을 다해봐요!"),
        Trainer(id: 3, name: "기가채드", imageName: "chad_character", motivation: "자신을 믿으세요. 당신은 생각보다 훨씬 강합니다!")
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 트레이너 선택 섹션
                VStack(alignment: .leading, spacing: 16) {
                    Text("트레이너 선택")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(trainers) { trainer in
                                TrainerCard(
                                    trainer: trainer,
                                    isSelected: selectedTrainer == trainer.id
                                ) {
                                    selectedTrainer = trainer.id
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 선택된 트레이너의 동기부여 멘트
                VStack(spacing: 12) {
                    Text("💬 오늘의 메시지")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(trainers[selectedTrainer].motivation)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // 선택 완료 버튼
                Button(action: {
                    print("선택된 트레이너: \(trainers[selectedTrainer].name)")
                }) {
                    Text("트레이너 선택 완료")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("트레이너 선택")
        }
    }
}

struct TrainerCard: View {
    let trainer: Trainer
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(trainer.imageName)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .foregroundColor(isSelected ? .blue : .gray)
                    .padding(EdgeInsets(top: 10, leading: 6, bottom: 2, trailing: 6))
                
                Text(trainer.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .blue : .primary)
            }
            .frame(width: 120, height: 140)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SelectCharacterView()
}
