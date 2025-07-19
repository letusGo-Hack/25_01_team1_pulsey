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
            Tab("홈", systemImage: "house") {
                HomeView()
            }
            Tab("캘린더", systemImage: "calendar") {
                CalendarView()
            }
        }
    }
}

#Preview {
    MainView()
}
