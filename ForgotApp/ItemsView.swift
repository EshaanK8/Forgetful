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
    var data: [Place]
    //var dataDict: [String:Place]
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var category: String
    var categoryName: String
    //@State var itemsArray: [String.SubSequence]
    @State var itemObjectArray: [Item]
    
    init(currentMapItem: MKMapItem) {
        self.currentMapItem = currentMapItem
        self.category = currentMapItem.pointOfInterestCategory?.rawValue ?? "None"
        self.categoryName = currentMapItem.pointOfInterestCategory?.rawValue.replacingOccurrences(of: "MKPOICategory", with: "") ?? "Unable to find location type"
        self.data = SQLiteCommands.presentRows() ?? [Place]()
        //self.dataDict = SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]()
        //self.itemsArray = (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[currentMapItem.pointOfInterestCategory?.rawValue ?? "None"]!.items.split(separator: ",")
        self.itemObjectArray = (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[currentMapItem.pointOfInterestCategory?.rawValue ?? "None"]!.items.split(separator: ",").map {Item(name: String($0))}
    }
    
    var body: some SwiftUI.View {
        
        NavigationView {
            VStack {
                Text(String(categoryName))
                    .navigationTitle(String(describing: currentMapItem.name!))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                Text("Some things you may want to bring with you")
                
                if (category != "None") {
                    
                    /*
                    for item in itemsArray.count {
                        
                    }*/
                    
                    
                    Button(action: {
                        if (SQLiteCommands.addItem(placeKey:category, item:"Hat")!) {
                            //self.dataDict = SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]()
                            itemObjectArray = (SQLiteCommands.convertDatabaseToDictionary() ?? [String:Place]())[category]!.items.split(separator: ",").map {Item(name: String($0))}
                        }
                    }) {
                        Text("Add item for location type " + categoryName)
                    }
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .clipShape(Capsule())
                    
                    ScrollView {
                        LazyVGrid(columns: layout, spacing: 20) {
                            ForEach(itemObjectArray, id: \.self) { item in
                                CardView(title:item.name)
                            }
                        }
                        .padding(.horizontal)
                    }
                    Spacer()
                    Button(action: {print("Hello")}) {
                        Text("Directions")
                    }
                    .padding()
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .clipShape(Capsule())
                }
            }
        }
        .border(Color.green)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

/*
func getData(category: String) -> [Item] {
    let defaults = UserDefaults.standard
    var dataDict: [String:[Item]]
    
    dataDict = defaults.object(forKey: DefaultsKeys.items) as? [String : [Item]] ?? [String : [Item]]()

    return dataDict[category]!
}*/



/*
struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        //ItemsView()
    }
}*/
