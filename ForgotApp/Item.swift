//
//  Item.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-15.
//

import Foundation

struct Item: Hashable, Identifiable {
    var name = ""
    let id = UUID()
    
    init(name: String) {
        self.name = name
    }
}
