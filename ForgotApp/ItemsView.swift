//
//  ItemsView.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-07.
//

import SwiftUI
import MapKit

struct ItemsView: View {
    var currentMapItem: MKMapItem
    
    var body: some View {
        Text(String(describing: currentMapItem.name))
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(currentMapItem: MKMapItem())
    }
}
