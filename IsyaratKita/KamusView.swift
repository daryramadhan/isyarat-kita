//
//  KamusView.swift
//  SignRecognitionVersion11
//
//  Created by Dary Ramadhan on 06/06/24.
//

import SwiftUI

struct KamusView: View {

    @State var selectedCategory: String = ""
    @State var selectedKamus: String = ""
    
//    var images: [Image]
//    let kamusKata : [String] = ["aku", "kamu", "cinta", "mana", "berapa", "cantik", "ganteng", "terimakasih", "pintar", "makan", "mandi", "jalan", "nama", "sekolah", "sehat", "semangat", "hai", "apa", "kabar", "kapan",]
    
    let kamusKata : [String] = ["aku", "cinta", "terimakasih", "nama", "hai"]
    
    //    @Environment(\.dismiss) var dismiss
    let kamusHuruf : [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",]
    
    let kamusAngka : [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var images: [String] {
        switch selectedCategory {
        case "Huruf" :
            return kamusHuruf
        case "Angka" :
            return kamusAngka
        case "Kata" :
            return kamusKata
        default:
            return []
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(images, id: \.self) { item in
                            Image(item)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
//                            .border(.blue)
                    }
                }
                .padding()
            }
            .navigationTitle("Kamus \(selectedCategory)")
        }
    }
}

#Preview {
    KamusView()
}
