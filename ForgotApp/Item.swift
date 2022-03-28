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
    var isDeleting: Bool
    
    init(name: String, isDeleting: Bool) {
        self.name = name
        self.isDeleting = isDeleting
    }
}
