import SwiftUI
import AVFoundation
import Vision
import Foundation


struct CameraPreview: UIViewRepresentable {
    @Binding var recognizedText: String
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.recognizedTextHandler = { text in
            self.recognizedText = text
        }
        return view
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) { }
}

