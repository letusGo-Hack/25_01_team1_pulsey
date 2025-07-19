//
//  ContentView.swift
//  pulsey
//
//  Created by 정종찬 on 7/19/25.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    var body: some View {
        Text(text)
            .task {
                do {
                    text = try await CharacterManager.shared.respond(character: .frieren, "ㅎㅇ")
                } catch {
                    print(error)
                }
            }
    }
}

#Preview {
    ContentView()
}
