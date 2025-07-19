//
//  LaunchScreenView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        Image("AppIconImage")
            .resizable()
            .frame(width: 128, height: 128)
            .clipShape(.rect(cornerRadius: 32))
    }
}

struct LaunchScreenViewModifier<C: View>: ViewModifier {
    @State private var opacity: Double = 1.0
    
    private let duration: Double
    private let content: () -> C
    
    init(duration: Double, content: @escaping () -> C) {
        self.duration = duration
        self.content = content
    }
    
    func body(content: Content) -> some View {
        if opacity == 0 {
            content
        } else {
            self.content()
                .opacity(opacity)
                .task {
                    try? await Task.sleep(for: .seconds(duration))
                    withAnimation {
                        opacity = 0
                    }
                }
        }
    }
}

extension View {
    func launchScreen<C: View>(duration: Double = 1.5, content: @escaping () -> C) -> some View {
        self.modifier(LaunchScreenViewModifier(duration: duration, content: content))
    }
}

#Preview {
    LaunchScreenView()
}
