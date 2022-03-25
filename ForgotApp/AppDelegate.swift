//
//  AppDelegate.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-20.
//

import Foundation
import SwiftUI
import SQLite

class AppDelegate: NSObject, UIApplicationDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let defaults = UserDefaults.standard
        let hasLaunched = isAppAlreadyLaunchedOnce()
        
            if !hasLaunched {
                createTable()
                addPlace(Place(name: "Airport", items: "", key:"MKPOICategoryAirport"))
                addPlace(Place(name: "Amusement Park", items: "", key:"MKPOICategoryAmusementPark"))
                addPlace(Place(name: "Aquarium", items: "", key:"MKPOICategoryAquarium"))
                addPlace(Place(name: "ATM", items: "", key:"MKPOICategoryATM"))
                addPlace(Place(name: "Bakery", items: "", key:"MKPOICategoryBakery"))
                addPlace(Place(name: "Bank", items: "", key:"MKPOICategoryBank"))
                addPlace(Place(name: "Beach", items: "", key:"MKPOICategoryBeach"))
                addPlace(Place(name: "Brewery", items: "", key:"MKPOICategoryBrewery"))
                addPlace(Place(name: "Cafe", items: "", key:"MKPOICategoryCafe"))
                addPlace(Place(name: "Campground", items: "", key:"MKPOICategoryCampground"))
                addPlace(Place(name: "Car Rental", items: "", key:"MKPOICategoryCarRental"))
                addPlace(Place(name: "EV Charger", items: "", key:"MKPOICategoryEVCharger"))
                addPlace(Place(name: "Fire Station", items: "", key:"MKPOICategoryFireStation"))
                addPlace(Place(name: "Fitness Center", items: "", key:"MKPOICategoryFitnessCenter"))
                addPlace(Place(name: "Food Market", items: "", key:"MKPOICategoryFoodMarket"))
                addPlace(Place(name: "Gas Station", items: "", key:"MKPOICategoryGasStation"))
                addPlace(Place(name: "Hospital", items: "", key:"MKPOICategoryHospital"))
                addPlace(Place(name: "Hotel", items: "", key:"MKPOICategoryHotel"))
                addPlace(Place(name: "Laundry", items: "", key:"MKPOICategoryLaundry"))
                addPlace(Place(name: "Library", items: "", key:"MKPOICategoryLibrary"))
                addPlace(Place(name: "Marina", items: "", key:"MKPOICategoryMarina"))
                addPlace(Place(name: "Movie Theater", items: "", key:"MKPOICategoryMovieTheater"))
                addPlace(Place(name: "Museum", items: "", key:"MKPOICategoryMuseum"))
                addPlace(Place(name: "National Park", items: "", key:"MKPOICategoryNationalPark"))
                addPlace(Place(name: "Nightlife", items: "", key:"MKPOICategoryNightlife"))
                addPlace(Place(name: "Park", items: "", key:"MKPOICategoryPark"))
                addPlace(Place(name: "Parking", items: "", key:"MKPOICategoryParking"))
                addPlace(Place(name: "Pharmacy", items: "", key:"MKPOICategoryPharmacy"))
                addPlace(Place(name: "Police", items: "", key:"MKPOICategoryPolice"))
                addPlace(Place(name: "Post Office", items: "", key:"MKPOICategoryPostOffice"))
                addPlace(Place(name: "Public Transport", items: "", key:"MKPOICategoryPublicTransport"))
                addPlace(Place(name: "Restaurant", items: "Wallet,Mask,Keys", key:"MKPOICategoryRestaurant"))
                addPlace(Place(name: "Restroom", items: "", key:"MKPOICategoryRestroom"))
                addPlace(Place(name: "School", items: "", key:"MKPOICategorySchool"))
                addPlace(Place(name: "Stadium", items: "", key:"MKPOICategoryStadium"))
                addPlace(Place(name: "Store", items: "", key:"MKPOICategoryStore"))
                addPlace(Place(name: "Theater", items: "", key:"MKPOICategoryTheater"))
                addPlace(Place(name: "University", items: "", key:"MKPOICategoryUniversity"))
                addPlace(Place(name: "Winery", items: "", key:"MKPOICategoryWinery"))
                addPlace(Place(name: "Zoo", items: "", key:"MKPOICategoryZoo"))
                addPlace(Place(name: "None", items: "", key:"None"))
                presentTable()
            }
        
        return true
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
            
        if defaults.bool(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    private func addPlace(_ place:Place) {
        let placeAddedToTable = SQLiteCommands.insertRow(place)
        
        if placeAddedToTable == false {
            print("Place already added")
        }
    }
    
    private func presentTable() {
        SQLiteCommands.presentRows()
    }
}
