//
//  APIManager.swift
//  gravityAI remix
//
//  Created by Rahul K M on 17/01/24.
//

//import Foundation
//
//class APIManager {
//    
//    let endpointURL = "https://api-inference.huggingface.co/models/MBZUAI/LaMini-Flan-T5-248M"
//
// 
//    let apiKey = ""
//
//    func fetchResponse(for userInput: String, completion: @escaping (String) -> Void) {
//        guard let url = URL(string: endpointURL) else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let payload = RequestPayload(inputs: userInput)
//        guard let httpBody = try? JSONEncoder().encode(payload) else {
//            print("Error encoding request body")
//            return
//        }
//        request.httpBody = httpBody
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("Error making request: \(error.localizedDescription)")
//                return
//            }
//
//            guard let data = data else {
//                print("No data received")
//                return
//            }
//
//            if let apiResponse = try? JSONDecoder().decode(APIResponse.self, from: data) {
//                DispatchQueue.main.async {
//                    completion(apiResponse.generateResponse())
//                }
//            } else {
//                print("Error decoding response")
//            }
//        }.resume()
//    }
//}
//
//struct RequestPayload: Codable {
//    let inputs: String
//}
//
//struct APIResponse: Codable {
//    let generated_text: String?
//    
//    func generateResponse() -> String {
//        return generated_text ?? "No response generated."
//    }
//}
