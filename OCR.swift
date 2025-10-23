//
//  OCR.swift
//  TR2
//
//  Created by Pranav Bhatia on 22/10/25.
//

//import Vision
//
//func recognizeText(from sampleBuffer: CMSampleBuffer, completion: @escaping (String) -> Void) {
//    guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
//    
//    let request = VNRecognizeTextRequest { request, error in
//        guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//        let detectedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
//        completion(detectedText)
//    }
//    
//    request.recognitionLevel = .accurate
//    request.recognitionLanguages = ["en"] // Can be dynamic
//    
//    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//    try? handler.perform([request])
//}
