//
//  CardView.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-13.
//

import SwiftUI

struct CardView: View {
    
    let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title)
        }
        .padding()
        .frame(width: 160, height: 160)
        .background(Color(red: 0, green: 0, blue: 0.5).opacity(0.5))
        .cornerRadius(15)
    }
}
