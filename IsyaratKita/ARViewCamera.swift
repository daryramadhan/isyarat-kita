//
//  ARViewCamera.swift
//  SignRecognitionVersion11
//
//  Created by Dary Ramadhan on 20/05/24.
//

import SwiftUI
import ARKit

struct ARViewCamera: View {
    @Binding var classifiedSign: String
    @Binding var handPoseConfidence: Double
    @Binding var confidence: Double
    
    @Binding var handDetected: Bool
    @Binding var categorySelected: String

    @State private var arSession = ARSession()
    
    var body: some View {
        ZStack {
            ARViewController(classifiedSign: $classifiedSign, handPoseConfidence: $handPoseConfidence, confidence: $confidence, handDetected: $handDetected, categorySelected: $categorySelected, session: arSession)
        }
        .onAppear {
            let configuration = ARFaceTrackingConfiguration()
            configuration.isWorldTrackingEnabled = true
            arSession.run(configuration)
        }
    }
}
