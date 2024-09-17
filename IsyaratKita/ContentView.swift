//
//  ContentView.swift
//  SignRecognitionVersion11
//
//  Created by Dary Ramadhan on 20/05/24.
//

import SwiftUI
import ARKit

struct ContentView: View {
    
    @State private var showingKamus = false
    @State var showSkeleton = false
    
    @State var classifiedSign = "none"
    @State var confidence: Double = 0.0
    @State var handPoseConfidence: Double = 0.0
    
    @State private var ask: Bool = false
    
    @State var handDetected: Bool = false
    
    @State var selectedCategory: String = "Huruf"
    
    let categoryName = ["Huruf", "Angka", "Kata"]

    
    var body: some View {
        ZStack (alignment: .leading) {
            VStack (alignment: .leading) {
                
                //MARK: Header Atas
                HStack(alignment: .center) {
                    VStack (alignment: .leading) {
                        Text("Indonesian Hand Sign Recognition")
                            .font(.headline)
                        Text("Dary Ramadhan - 2440075220")
                            .font(.caption)
                    }
                    Spacer()
                    
                    Circle()
                        .frame(width: 12, height: 12)
                        .padding()
                        .foregroundColor(handDetected ? .green : .red)
                    
                }
                .padding(.bottom)
                
                //MARK: Picker Area
                VStack (alignment: .leading) {
    
//                    Text("Pilih bahasa isyarat dibawah ini,")
                    Picker("Choose category", selection: $selectedCategory) {
                        ForEach(categoryName, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.bottom)

                //MARK: Main View
                ZStack() {
                    Rectangle()
                        .strokeBorder()
                        .overlay {
                            ARViewCamera(classifiedSign: $classifiedSign, handPoseConfidence: $handPoseConfidence, confidence: $confidence, handDetected: $handDetected, categorySelected: $selectedCategory)
                        }
                        .border(.yellow) 
                    
                    ZStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(" \(classifiedSign) ")
                                        .font(.title)
                                        .background(.yellow)
                                    Text(" Confidence: \(handPoseConfidence) ")
                                        .background(.yellow)
                                    Text(" \(confidence) ")
                                        .background(.yellow)
                                }
                                Spacer()
//                                Image(systemName: "camera")
//                                    .foregroundColor(.blue)
//                                VStack(alignment:.trailing, spacing: 6){
//                                    Text("Skeleton")
//                                        .font(.caption)
//                                    Toggle(isOn: $showSkeleton, label: {
//                                        Text("Show Skeleton")
//                                    })
//                                    .labelsHidden()
//                                }
                                
                            }
                        }
                        .padding()
                    }
                }
              
                Button(action: {
                    showingKamus.toggle()
                }, label: {
                    Text("Kamus \(selectedCategory)")
                        .foregroundStyle(.black)
                        .frame(width: 362, height: 60)
                        .background(.yellow)
                })
                .sheet(isPresented: $showingKamus, content: {
                    KamusView(selectedCategory: selectedCategory)
                })
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
