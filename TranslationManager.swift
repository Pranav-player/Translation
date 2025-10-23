
//  TranslationManager.swift
//  TR2
//
//  Created by Pranav Bhatia on 20/09/25.
//


import Foundation
class TranslationManager: ObservableObject {
    @Published var translatedText = ""
    
    func translateText(input: String, from: String, to: String, completion: ((String) -> Void)? = nil) {
        let escapedInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? input
        
        guard let url = URL(string: "https://free-google-translator.p.rapidapi.com/external-api/free-google-translator?from=\(from)&to=\(to)&query=\(escapedInput)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("free-google-translator.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        request.setValue("b99a1967eamsh7f1fa37a4f37c5fp176954jsn6ae7ef90914e", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            guard let data = data else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let translation = json["translation"] as? String {
                    DispatchQueue.main.async {
                        self.translatedText = translation
                        completion?(translation)
                    }
                } else {
                    print("Parse failed:", String(data: data, encoding: .utf8) ?? "")
                }
            } catch {
                print("JSON Error:", error)
            }
        }
        task.resume()
    }
}

