//
//  ARViewController.swift
//  SignRecognitionVersion11
//
//  Created by Dary Ramadhan on 20/05/24.
//

import Vision
import SwiftUI
import ARKit

struct ARViewController: UIViewRepresentable {
    
    @Binding var classifiedSign : String
    @Binding var handPoseConfidence: Double
    @Binding var confidence: Double
    
    @Binding var handDetected: Bool
    @Binding var categorySelected: String
    
    var session: ARSession
    var queue = [MLMultiArray]()
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.session = session
        arView.autoenablesDefaultLighting = true
        arView.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    typealias UIViewType = ARSCNView
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        private let parent: ARViewController
        private var interval : Int
        
        private var handPoseObservations = [MLMultiArray]()
        
        var frameCounter: Int = 0
        let handPosePredictionInterval: Int = 30
        
        init(_ parent: ARViewController) {
            self.parent = parent
            self.interval = 0
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            
            guard let frame = parent.session.currentFrame else {
                return
            }
            // Convert ARFrame to CVPixelBuffer
            let pixelBuffer = frame.capturedImage
            // Perform hand pose detection
            detectHandPose(pixelBuffer: pixelBuffer)
            
        }
        
        func detectHandPose(pixelBuffer: CVPixelBuffer) {
            
            // Create a hand pose detection request
            let handPoseRequest = VNDetectHumanHandPoseRequest { vnRequest, error in
                DispatchQueue.main.async {
                    if let results = vnRequest.results as? [VNHumanHandPoseObservation], results.count > 0 {
                        print("✅ Detected \(results.count) hands!")
                        self.parent.handDetected = true
                    } else {
                        print("❌ No hand detected")
                        self.parent.handDetected = false
                    }
                }
            }
            
            // Number of hands to get
            handPoseRequest.maximumHandCount = 2
            
            // Execute a detection request on the camera frame
            // The frame acquired from the camera is rotated 90 degrees, and if you infer it as it is, the pose may not be recognized correctly, so check the orientation.
            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
            do {
                try handler.perform([handPoseRequest])
            } catch {
                assertionFailure("Hand Pose Request failed: \(error)")
            }
            
            guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
                return
            }
            
            let handObservation = handPoses.first
            
            guard let keypointsMultiArray = try? handObservation!.keypointsMultiArray() else {
                fatalError("Failed to convert keypoints")
            }
            
            handPoseObservations.append(keypointsMultiArray)
            
            //MARK: Hand Pose = Abjad
            guard let handPoseModel = try? SIBI_Huruf_Model_Classifier(configuration: MLModelConfiguration()) else {
                fatalError("Failed to load the huruf model classifier")
            }
            
            //MARK: Hand Pose = Angka
            guard let handPoseModelDigits = try? SIBI_Number_Model_Classification(configuration: MLModelConfiguration()) else {
                fatalError("Failed to load the angka model classifier")
            }
        
            //MARK: Hand Action = Kata
            guard let handActionModel = try? SIBI_Kata_Model_Classifier(configuration: MLModelConfiguration()) else {
                fatalError("Failed to load the hand action model")
            }
            
            do {
                guard let keypointsMultiArray = try? handObservation?.keypointsMultiArray()
                else { fatalError() }
                
                handPoseObservations.append(keypointsMultiArray)
                
                let prediction = try handPoseModel.prediction(poses: keypointsMultiArray)
                let label = prediction.label
                guard let confidence = prediction.labelProbabilities[label] else { return }
                
                let digitsPrediction = try handPoseModelDigits.prediction(poses: keypointsMultiArray)
                let digitsLabel = digitsPrediction.label
                guard let digitsConfidence = digitsPrediction.labelProbabilities[digitsLabel] else { return }
                
                print(handPoseObservations.count)
                
                switch self.parent.categorySelected {
                    
                case "Huruf" :
                    self.parent.classifiedSign = label
                    self.parent.confidence = confidence
                    
                    if confidence > 0.7 {
                        self.parent.handPoseConfidence = confidence
                        print(confidence)
                        handPoseObservations.removeAll()
                    }
                    
                case "Angka" :
                    self.parent.classifiedSign = digitsLabel
                    self.parent.confidence = digitsConfidence
                    
                    if digitsConfidence > 0.7 {
                        self.parent.handPoseConfidence = digitsConfidence
                        print(digitsConfidence)
                        handPoseObservations.removeAll()
                    }
                    
                case "Kata" :
                    if handPoseObservations.count == 30 {
                        
                        let combinedMultiArray = MLMultiArray(concatenating: handPoseObservations, axis: 0, dataType: .float32)
                        handPoseObservations.removeAll()
                        
                        let handActionPrediction = try handActionModel.prediction(poses: combinedMultiArray)
                        let actionLabel = handActionPrediction.label
                        guard let actionConfidence = handActionPrediction.labelProbabilities[actionLabel] else { return }
                        
                        self.parent.classifiedSign = actionLabel
                        self.parent.confidence = actionConfidence
                        self.parent.handPoseConfidence = actionConfidence
                        print(actionConfidence)
                    }
                    
                default:
                    print("invalid")
                }
        
            } catch {
                print("Error here")
            }
            
        }
        
    }
}



