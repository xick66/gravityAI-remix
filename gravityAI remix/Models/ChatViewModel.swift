//    private let apiURL = "https://api-inference.huggingface.co/models/MBZUAI/LaMini-Flan-T5-248M"

//  ChatViewModel.swift
//  gravityAI remix
//
//  Created by Rahul K M on 17/01/24.
//

import Foundation
import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var conversations: [String] = ["Conversation 1"]
    @Published var currentConversationIndex = 0
    @Published var userInput: String = ""
    
    private let apiURL = "https://api-inference.huggingface.co/models/MBZUAI/LaMini-Flan-T5-248M"
    private let apiKey = "Bearer API_KEY"
    
    func startNewConversation() {
        let newConversationTitle = "Conversation \(conversations.count + 1)"
        conversations.append(newConversationTitle)
        currentConversationIndex = conversations.count - 1
    }
    
    func sendMessage(_ messageText: String) {
        let userMessage = ChatMessage(
            message: messageText,
            isUser: true,
            sender: "You",
            conversationID: currentConversationIndex
        )
        DispatchQueue.main.async {
            self.messages.append(userMessage)
        }

        fetchResponse(for: messageText)
        
        DispatchQueue.main.async {
            self.userInput = ""
        }
    }

    
    private func fetchResponse(for userInput: String) {
        guard let url = URL(string: apiURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = RequestPayload(inputs: userInput)
        
        guard let httpBody = try? JSONEncoder().encode(payload) else {
            print("Error encoding request body")
            return
        }
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    guard let self = self else { return }

                    if let error = error {
                        print("Error making request: \(error.localizedDescription)")
                        return
                    }

                    guard let data = data else {
                        print("No data received")
                        return
                    }
            
            do {
                         let apiResponses = try JSONDecoder().decode([APIResponse].self, from: data)
                         if let firstResponse = apiResponses.first, let generatedText = firstResponse.generated_text {
                             DispatchQueue.main.async {
                                 let responseMessage = ChatMessage(
                                     message: generatedText,
                                     isUser: false,
                                     sender: "Gravity",
                                     conversationID: self.currentConversationIndex
                                 )
                                 self.messages.append(responseMessage)
                             }
                         }
                     } catch {
                         print("JSON decoding error: \(error.localizedDescription)")
                     }
                 }.resume()
             }
         }

struct ChatMessage: Identifiable {
    let id = UUID()
    let message: String
    let isUser: Bool
    let sender: String
    let conversationID: Int
}

struct RequestPayload: Codable {
    let inputs: String
}

struct APIResponse: Codable {
    let generated_text: String?
}

