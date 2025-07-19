//
//  HomeView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct HomeView: View {
    @State private var prompt = ""
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text("(캐릭터)")
                Text("")
                Spacer()
                HStack {
                    TextField("ㅇㅇ에게 질문해보세요", text: $prompt)
                    Button {
                        print("send")
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
    }
}
