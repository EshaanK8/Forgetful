//
//  Row.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-22.
//

import Foundation

struct Place: Hashable {
    var name: String
    var items: String
    var key: String
    
    init(name: String, items: String, key: String) {
        self.name = name
        self.items = items
        self.key = key
    }
}
