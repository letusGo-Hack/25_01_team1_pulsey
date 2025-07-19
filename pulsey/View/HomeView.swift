//
//  HomeView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI
import FoundationModels

struct HomeView: View {
    @State private var characterMessage = ""
    @State private var prompt = ""
    @AppStorage("selectedTrainer") private var selectedTrainerId: Int = 0
    private var selectedTrainer: Trainer? {
        Trainer.allTrainers.findTrainer(id: selectedTrainerId)
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let selectedTrainer {
                VStack(spacing: 12) {
                    Image(selectedTrainer.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 192)
                        .clipShape(.rect(cornerRadius: 12))
                    Text(selectedTrainer.name)
                        .bold()
                        .font(.title3)
                }
                .overlay {
                    MessageView(message: "characterMessage")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, -54)
                }
            }
            
            Spacer()
            HStack {
                if let selectedTrainer {
                    TextField("\(selectedTrainer.name)에게 질문해보세요", text: $prompt)
                        .padding(12)
                        .advancedFocus()
                }
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(4)
                }
                .padding(.trailing, 4)
            }
            .padding(4)
            .background(.white)
            .clipShape(.rect(cornerRadius: .infinity))
            .shadow(color: .black.opacity(0.04), radius: 3, y: 4)
            .padding(.bottom, 24)
            .padding(.horizontal, 16)
        }
    }
    
    func sendMessage() {
        guard let selectedTrainer else { return }
        Task {
            do {
                for try await response in TrainerManager.shared.respond(trainer: selectedTrainer, prompt) {
                    self.characterMessage = response
                }
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
