//
//  MainView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("홈", systemImage: "home") {
                HomeView()
            }
            Tab("대쉬보드", systemImage: "home") {
                Text("dashboard")
            }
        }
//        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    MainView()
}
