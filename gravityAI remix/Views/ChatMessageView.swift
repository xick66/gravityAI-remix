//
//  ChatMessageView.swift
//  gravityAI remix
//
//  Created by Rahul K M on 17/01/24.
//

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            Text(message.message)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray)
                .cornerRadius(10)
            if !message.isUser {
                Spacer()
            }
        }
    }
}
