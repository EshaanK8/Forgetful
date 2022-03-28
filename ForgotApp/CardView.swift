//
//  CardView.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-13.
//

import SwiftUI

struct CardView: View {
    
    let title: String
    let isSelected: Bool
    
    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    var body: some View {
        
        if !isSelected {
            VStack {
                Text(title)
            }
            .padding()
            .frame(width: 160, height: 160)
            .background(Color(red: 0, green: 0, blue: 0.5).opacity(0.5))
            .cornerRadius(15)
        }
        
        else {
            VStack {
                VStack {
                    Text(title)
                }
                .padding()
                .frame(width: 160, height:80)
                .background(Color(red: 0, green: 0, blue: 0.5).opacity(0.5))
                .cornerRadius(15, corners: [.topLeft, .topRight])
                VStack {
                    Text("Delete")
                }
                .padding()
                .frame(width: 160, height: 80)
                .background(Color(red: 0.5, green: 0, blue: 0).opacity(0.5))
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            }
        }
    }
}
