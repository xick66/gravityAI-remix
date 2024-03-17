//
//  ContentView.swift
//  gravityAI remix
//
//  Created by Rahul K M on 17/01/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var chatViewModel = ChatViewModel()
    @State private var userInput: String = ""
    @State private var sidebarWidth: CGFloat = 200

    var body: some View {
        HStack {
            sidebar
            
            mainChatArea
        }
    }
    
    var sidebar: some View {
        VStack {
            Spacer(minLength: 20) 
            
            // New Chat button
            Button(action: chatViewModel.startNewConversation) {
                Text("New Chat")
                    .bold()
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 10)
            
            // List of conversations
            List(chatViewModel.conversations, id: \.self) { conversation in
                Button(action: {
                    chatViewModel.currentConversationIndex = chatViewModel.conversations.firstIndex(of: conversation) ?? 0
                }) {
                    Text(conversation)
                        .bold()
                        .foregroundColor(.orange)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .frame(width: sidebarWidth)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    var mainChatArea: some View {
        VStack {
                        ScrollView {
                            ForEach(chatViewModel.messages.filter { $0.conversationID == chatViewModel.currentConversationIndex }) { message in
                                ChatMessageView(message: message)
                            }
                        }
                        .padding()

                        // Input and send button
            HStack {
                       TextField("Type your message here...", text: $chatViewModel.userInput, onCommit: {
                           if !chatViewModel.userInput.isEmpty {
                               chatViewModel.sendMessage(chatViewModel.userInput)
                              
                           }
                       })
                       .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                                if !chatViewModel.userInput.isEmpty {
                                    chatViewModel.sendMessage(chatViewModel.userInput)
                                    
                                }
                            }) {
                                Text("Send")
                            }
                            .disabled(chatViewModel.userInput.isEmpty)
                        }
                        .padding()
                        }
                    }
                }
   
struct ChatMessageView: View {
    var message: ChatMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("\(message.sender):")
                .bold()
                .foregroundColor(message.isUser ? .blue : .orange)
                .font(.system(size: 16))
            
            Text(message.message)
                .font(.system(size: 16))
                .padding(.leading, 20)
            
            Divider()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: message.isUser ? .leading : .trailing)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
