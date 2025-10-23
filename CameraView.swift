import SwiftUI
import AVFoundation
import Vision
import Foundation

struct CameraView: View {
    @State private var recognizedText = ""
    @StateObject var translator = TranslationManager()
    
    @State private var fromLanguage = "auto"
    @State private var toLanguage = "en"
    
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
        ZStack(alignment: .bottom) {
            CameraPreview(recognizedText: $recognizedText)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
           
                Text(recognizedText)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                
                HStack {
                    Picker("From", selection: $fromLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { code in
                            Text(languages[code] ?? code).tag(code)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    Picker("To", selection: $toLanguage) {
                        ForEach(languages.keys.sorted(), id: \.self) { code in
                            Text(languages[code] ?? code).tag(code)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding(.horizontal)
                
    
                Button("Translate") {
                    translator.translateText(input: recognizedText, from: fromLanguage, to: toLanguage)
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
             
                Text(translator.translatedText)
                    .padding()
                    .background(Color.blue.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}
