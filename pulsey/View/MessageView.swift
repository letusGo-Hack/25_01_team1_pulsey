//
//  MessageView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct MessageView: View {
    @State private var index = 0
    @State private var displayedContent: [Swift.Character] = []
    @State private var timer: Timer?
    @Binding var isPlaying: Bool
    
    let message: String
    
    var body: some View {
        FlowLayout {
            HStack(spacing: 0) {
                ForEach(Array(displayedContent.enumerated()), id: \.0) { _, char in
                    CharacterView(
                        character: char
                    )
                }
            }
        }
        .padding(15)
        .onChange(of: message, initial: true) { _, newValue in
            displayedContent = []
            isPlaying = true
            index = 0
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { timer in
                if index >= newValue.count {
                    timer.invalidate()
                    isPlaying = false
                    return
                }
                
                let newChar = newValue[newValue.index(newValue.startIndex, offsetBy: index)]
                
                DispatchQueue.main.async {
                    withAnimation(.easeIn(duration: 0.2)) {
                        displayedContent.append(newChar)
                    }
                    index += 1
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
            isPlaying = false
        }
    }
}

private struct CharacterView: View {
    let character: Swift.Character
    
    @State private var opacity = 0.0
    
    var body: some View {
        Text(String(character))
            .font(.system(size: 15))
            .opacity(opacity)
            .animation(.easeIn(duration: 0.5), value: opacity)
            .onAppear {
                withAnimation {
                    opacity = 1.0
                }
            }
    }
}
