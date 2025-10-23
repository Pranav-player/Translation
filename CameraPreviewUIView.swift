import SwiftUI
import AVFoundation
import Vision
import Foundation

class CameraPreviewUIView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
    let session = AVCaptureSession()
    var recognizedTextHandler: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCamera()
    }
    
    private func setupCamera() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else { return }
            DispatchQueue.main.async {
                self.session.sessionPreset = .high
                
                guard let camera = AVCaptureDevice.default(for: .video),
                      let input = try? AVCaptureDeviceInput(device: camera),
                      self.session.canAddInput(input) else { return }
                self.session.addInput(input)
                
            
                let previewLayer = AVCaptureVideoPreviewLayer(session: self.session)
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.frame = self.bounds
                self.layer.addSublayer(previewLayer)
                
                let output = AVCaptureVideoDataOutput()
                output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
                if self.session.canAddOutput(output) { self.session.addOutput(output) }
                
                self.session.startRunning()
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.sublayers?.forEach {
            ($0 as? AVCaptureVideoPreviewLayer)?.frame = self.bounds
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let detectedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            
            DispatchQueue.main.async {
                self.recognizedTextHandler?(detectedText)
            }
        }
        
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["en"]
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}
