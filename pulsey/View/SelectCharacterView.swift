//
//  SelectCharacterView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct SelectCharacterView: View {
    @AppStorage("selectedTrainer") private var selectedTrainerId: Int = 0
    private var selectedTrainer: Trainer? {
        Trainer.allTrainers.findTrainer(id: selectedTrainerId)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // 트레이너 선택 섹션
                VStack(alignment: .leading, spacing: 16) {
                    Text("트레이너 선택")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(Trainer.allTrainers) { trainer in
                                TrainerCard(
                                    trainer: trainer,
                                    isSelected: selectedTrainerId == trainer.id
                                ) {
                                    selectedTrainerId = trainer.id
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                if let selectedTrainer {
                    // 선택된 트레이너의 동기부여 멘트
                    VStack(spacing: 12) {
                        Text("💬 오늘의 메시지")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(selectedTrainer.motivation)
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
                        print("선택된 트레이너: \(selectedTrainer.name)")
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
                    .aspectRatio(contentMode: .fit)
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
