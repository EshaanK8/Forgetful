 //
//  ItemsView.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-07.
//

import SwiftUI
import MapKit
import SQLite

struct ItemsView: SwiftUI.View {
    
    var currentMapItem: MKMapItem
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let regionDistance: CLLocationDistance
    let coordinates: CLLocationCoordinate2D
    let regionSpan: MKCoordinateRegion
    let options: [String:NSValue]
    
    var data: [Place]
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var category: String
    var categoryName: String
    @State var itemObjectArray: [Item]
    var nilDict: [String:Place] = ["None":Place(name:"None", items: "", key: "None")]
    @State private var itemName: String = ""
    @State private var isAdding: Bool = false
    @State private var isDeleting: Bool = false
    @State var selectedItems: [Item] = []
    
    init(currentMapItem: MKMapItem) {
        self.currentMapItem = currentMapItem
        self.latitude = (currentMapItem.placemark.location?.coordinate.latitude)!
        self.longitude = (currentMapItem.placemark.location?.coordinate.longitude)!
        self.regionDistance = 1000
        self.coordinates = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        self.regionSpan = MKCoordinateRegion(center: self.coordinates, latitudinalMeters: self.regionDistance, longitudinalMeters: self.regionDistance)
        self.options = [MKLaunchOptionsMapCenterKey:NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey:NSValue(mkCoordinateSpan: regionSpan.span)]
        
        self.category = currentMapItem.pointOfInterestCategory?.rawValue ?? "None"
        self.categoryName = currentMapItem.pointOfInterestCategory?.rawValue.replacingOccurrences(of: "MKPOICategory", with: "") ?? "Unable to find location type"
        self.data = SQLiteCommands.presentRows() ?? [Place]()
        self._itemObjectArray = State(initialValue: (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[currentMapItem.pointOfInterestCategory?.rawValue ?? "None"]!.items.split(separator: ",").map {Item(name: String($0), isDeleting: false)})
    }
    
    var body: some SwiftUI.View {
        
        NavigationView {
            VStack {
                Text(String(categoryName))
                    .fontWeight(.light)
                    .navigationTitle(String(describing: currentMapItem.name!))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                    .padding(.bottom, 30)
                
                if (category != "None") {
                    Spacer()
                    Text("Don't forget to bring...")
                        .font(.system(size: 20.0))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)
                    ScrollView {
                        HStack() {
                            Spacer()
                            
                            if isAdding {
                                TextField(text: $itemName, prompt: Text("Enter Item Name")) {
                                    Text("Username")
                                }
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0.5))
                                .clipShape(Capsule())
                                .transition(.move(edge: .leading))
                                .scenePadding()
                                
                                Button(action: {
                                    if (SQLiteCommands.addItem(placeKey:category, item:itemName)!) {
                                        if (!itemName.isEmpty) {
                                            itemObjectArray = (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[category]!.items.split(separator: ",").map {Item(name: String($0), isDeleting: false)}
                                            withAnimation{isAdding.toggle()}
                                        }
                                    }
                                }) {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 30))
                                }
                                
                                Button(action: {withAnimation{isAdding.toggle()}}) {
                                    Image(systemName: "x.circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 30))
                                }
                                .padding()
                            }
                            
                            else {
                                Button(action: {withAnimation{isAdding.toggle()}}) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 30))
                                }
                                .padding()
                            }
                        }
                        
                        LazyVGrid(columns: layout, spacing: 20) {
                            ForEach(itemObjectArray, id: \.self) { item in
                                if !(selectedItems.contains(item)) {
                                    VStack {
                                        Text(item.name)
                                            .font(.system(size: 20.0))
                                    }
                                    .padding()
                                    .frame(width: 160, height: 160)
                                    .background(Color(red: 0.4, green: 0.7, blue: 0.8))
                                    .cornerRadius(15)
                                    .onTapGesture{
                                        selectedItems.append(item)
                                    }
                                }
                                
                                else {
                                    VStack {
                                        VStack {
                                            Text(item.name)
                                                .font(.system(size: 15.0)).italic()
                                        }
                                        .padding()
                                        .frame(width: 160, height:80)
                                        .background(Color(red: 0.4, green: 0.7, blue: 0.8))
                                        .cornerRadius(15, corners: [.topLeft, .topRight])
                                        .onTapGesture{
                                            selectedItems.remove(at: selectedItems.firstIndex(of: item)!)
                                        }
                                        
                                        VStack {
                                            Text("Delete")
                                        }
                                        .padding()
                                        .frame(width: 160, height: 80)
                                        .background(Color(red: 0.5, green: 0, blue: 0))
                                        .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                                        .onTapGesture{
                                            if (SQLiteCommands.removeItem(placeKey: category, item: item.name)!) {
                                                if (!item.name.isEmpty) {
                                                    itemObjectArray = (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[category]!.items.split(separator: ",").map {Item(name: String($0), isDeleting: false)}
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    Button(action: {openMap()}) {
                        VStack {
                            Spacer()
                            Text("Directions")
                                .font(.system(size: 25.0)).bold().foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
                    .background(Color(red: 0, green: 0, blue: 0.8))
                }
                
                else {
                    Button(action: {openMap()}) {
                        Text("Directions")
                    }
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .clipShape(Capsule())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func openMap() {
        currentMapItem.openInMaps(launchOptions: options)
    }

}



