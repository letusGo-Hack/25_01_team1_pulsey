//
//  MessageView.swift
//  pulsey
//
//  Created by hhhello0507 on 7/19/25.
//

import SwiftUI

struct MessageView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .padding(12)
            .glassEffect(in: .rect(cornerRadius: 18))
            .padding()
            .animation(.default, value: message)
    }
}
