//
//  ContentView.swift
//  TR2
//
//  Created by Pranav Bhatia on 20/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    var body: some View {
        TabView {
            TranslateView(historyViewModel: historyViewModel)
                .tabItem {
                    Label("Translate", systemImage: "character.bubble")
                }

            CameraView()
                .tabItem {
                    Label("Camera", systemImage: "camera.fill")
                }
            
            HistoryView(viewModel: historyViewModel) // pass to history
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            
        }
        .accentColor(.blue)
    }
}

struct TranslateView: View {
    
    @State private var inputText = ""
    @State private var fromLanguage = "auto"
    @State private var toLanguage = "es"
    @ObservedObject var translator = TranslationManager()
    @ObservedObject var historyViewModel: HistoryViewModel

    
    let languages: [String: String] = [
        "auto": "Auto Detect",
        "af": "Afrikaans", "sq": "Albanian", "am": "Amharic", "ar": "Arabic",
        "hy": "Armenian", "az": "Azerbaijani", "eu": "Basque", "be": "Belarusian",
        "bn": "Bengali", "bs": "Bosnian", "bg": "Bulgarian", "ca": "Catalan",
        "zh-CN": "Chinese (Simplified)", "zh-TW": "Chinese (Traditional)",
        "fr": "French", "de": "German", "hi": "Hindi", "en": "English",
        "es": "Spanish", "it": "Italian", "ja": "Japanese", "ko": "Korean",
        "ru": "Russian", "pt": "Portuguese", "ur": "Urdu",
        "ta": "Tamil", "te": "Telugu", "ml": "Malayalam", "tr": "Turkish",
        "vi": "Vietnamese", "sw": "Swahili", "th": "Thai", "pa": "Punjabi",
        "gu": "Gujarati"
    ]
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Translate")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.leading)
                
         
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(width: 380, height: 200)
                    
                    VStack(alignment: .leading) {
                        Picker("From", selection: $fromLanguage) {
                            ForEach(languages.keys.sorted(), id: \.self) { code in
                                Text(languages[code] ?? code).tag(code)
                            }
                        }
                        .padding()
                        .pickerStyle(MenuPickerStyle())
                        
                        TextField("Enter text", text: $inputText)
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
            
                HStack {
                    Spacer()
                    Button(action: {
                        let temp = fromLanguage
                        fromLanguage = toLanguage
                        toLanguage = temp
                    }) {
                        Image(systemName: "arrow.up.arrow.down.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                    }
                    Spacer()
                }


                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(width: 380, height: 200)
                    
                    VStack(alignment: .leading) {
                        Picker("To", selection: $toLanguage) {
                            ForEach(languages.keys.sorted(), id: \.self) { code in
                                Text(languages[code] ?? code).tag(code)
                            }
                        }
                        .padding()
                        .pickerStyle(MenuPickerStyle())
                        
                        Text(translator.translatedText)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
             
                HStack {
                    Spacer()
                    Button("Translate") {
                        translator.translateText(input: inputText, from: fromLanguage, to: toLanguage) { translated in
                            historyViewModel.addTranslation(translated)
                        }
                    }

                    .padding()
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
}
