//
//  CameraController.swift
//  SignRecognitionVersion11
//
//  Created by Dary Ramadhan on 20/05/24.
//

import SwiftUI
import AVFoundation
import Vision

//struct CameraController: UIViewControllerRepresentable {
//    
//    @Binding var classifiedSign: String
//    @Binding var confidence: String
//    
//    func makeUIViewController(context: Context) -> CameraViewControllerWrapper {
//        let viewController = CameraViewControllerWrapper()
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: CameraViewControllerWrapper, context: Context) {}
//    
//    typealias UIViewControllerType = CameraViewControllerWrapper
//    
////    class CameraViewControllerWrapper: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
////        private let captureSession = AVCaptureSession()
////        
////        
//////        override func viewDidLoad() {
//////            super.viewDidLoad()
//////            setupCaptureSession()
//////        }
////        
//////        override func viewDidAppear(_ animated: Bool) {
//////            super.viewDidAppear(animated)
////////            startCaptureSession()
//////        }
////        
//////        override func viewDidDisappear(_ animated: Bool) {
//////            super.viewDidDisappear(animated)
//////            stopCaptureSession()
//////        }
//////        
//////        private func setupCaptureSession() {
//////            guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
//////            
//////            do {
//////                let input = try AVCaptureDeviceInput(device: device)
//////                captureSession.addInput(input)
//////                
//////                let output = AVCaptureVideoDataOutput()
//////                output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CameraQueue"))
//////                captureSession.addOutput(output)
//////                
//////                let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//////                previewLayer.videoGravity = .resizeAspectFill
//////                previewLayer.frame = view.bounds
//////                view.layer.addSublayer(previewLayer)
//////            } catch {
//////                print("Failed to set up capture session:", error)
//////            }
//////        }
////        
//////        private func startCaptureSession() {
//////            captureSession.startRunning()
//////        }
////        
////        private func stopCaptureSession() {
////            captureSession.stopRunning()
////        }
////        
////        func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
////            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
////            
////            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
////            
////            do {
////                let handPoseRequest = VNDetectHumanHandPoseRequest()
////                try requestHandler.perform([handPoseRequest])
////                
////                guard let handPose = handPoseRequest.results, !handPose.isEmpty else {
////                    return
////                }
////                let handOservations = handPose.first
////                                            
////                guard let handPoseModel = try? BISINDO_Version_2(configuration: MLModelConfiguration()) else {
////                    fatalError("Failed to load the hand pose model")
////                }
////                
////                do {
////                    guard let keypointsMultiArray = try? handOservations?.keypointsMultiArray()
////                    else{
////                        fatalError()
////                    }
////                    
////                    let output: BISINDO_Version_2Output = try handPoseModel.prediction(poses: keypointsMultiArray)
////
////                    print(output.label)
////                    print(output.labelProbabilities.sorted{$0.value < $1.value})
////                    
////                    
////                    DispatchQueue.main.async {
//////
////                    }
////                }
////            } catch {
////                print("Error performing hand pose detection: \(error)")
////            }
////            
////        }
////
////    }
//}
