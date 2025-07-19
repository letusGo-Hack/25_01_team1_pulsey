//
//  HomeView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct HomeView: View {
    @State private var characterMessage = ""
    @State private var prompt = ""
    @State private var isPlaying = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("(캐릭터)")
                MessageView(isPlaying: $isPlaying, message: characterMessage)
                Spacer()
                HStack {
                    TextField("ㅇㅇ에게 질문해보세요", text: $prompt)
                        .padding(12)
                        .advancedFocus()
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
    }
    
    func sendMessage() {
        Task {
            do {
//                let response = CharacterManager.shared.respond(trainer: , prompt)
//                self.characterMessage = response
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    HomeView()
}
