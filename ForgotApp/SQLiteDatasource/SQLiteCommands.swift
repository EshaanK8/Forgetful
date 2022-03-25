//
//  SQLiteCommands.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-22.
//

import Foundation
import SQLite

class SQLiteCommands {
    static var table = Table("place")
    static let columns = [Expression<Int>("airport"), Expression<Int>("amusementPark"), Expression<Int>("aquarium"), Expression<Int>("atm"), Expression<Int>("bakery"), Expression<Int>("bank"), Expression<Int>("beach"), Expression<Int>("brewery"), Expression<Int>("cafe"), Expression<Int>("campground"), Expression<Int>("carRental"), Expression<Int>("evCharger"), Expression<Int>("fireStation"), Expression<Int>("fitnessCenter"), Expression<Int>("foodMarket"), Expression<Int>("gasStation"), Expression<Int>("hospital"), Expression<Int>("hotel"), Expression<Int>("laundry"), Expression<Int>("library"), Expression<Int>("marina"), Expression<Int>("movieTheater"), Expression<Int>("museum"), Expression<Int>("nationalPark"), Expression<Int>("nightlife"), Expression<Int>("park"), Expression<Int>("parking"), Expression<Int>("pharmacy"), Expression<Int>("police"), Expression<Int>("postOffice"), Expression<Int>("publicTransport"), Expression<Int>("restaurant"), Expression<Int>("restroom"), Expression<Int>("school"), Expression<Int>("stadium"), Expression<Int>("store"), Expression<Int>("theater"), Expression<Int>("university"), Expression<Int>("winery"), Expression<Int>("zoo")]
    static let name = Expression<String>("name")
    static let items = Expression<String>("items")
    static let key = Expression<String>("key")
    
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            try database.run(table.create(ifNotExists: true) { table in
                table.column(name)
                table.column(items)
                table.column(key, primaryKey: true)
            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    static func insertRow(_ place:Place) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        do {
            try database.run(table.insert(
                name <- place.name,
                items <- place.items,
                key <- place.key
            ))
            return true
        } catch let Result.error(message, code, statement) where
            code == SQLITE_CONSTRAINT {
            print("IOnsert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    /*
    // function to update user
    public func updateUser(idValue: Int64, nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            self.table = Table("place") // ==> need the assignment again to avoid issue
                
            // get user using ID
            let placeRow: Table = self.table.filter(self.key == placeKey)
                
            // run the update query
            try self.db.run(user.update(self.name <- nameValue, self.email <- emailValue, self.age <- ageValue))
        } catch {
            print(error.localizedDescription)
            print(error)
        }
    }*/
    
    static func addItem(placeKey:String, item:String) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        self.table = Table("place") //This is needed to avoid error
        let placeRow = self.table.filter(key == placeKey) //Get the row of the place we want to change
        
        do {
            try database.run(placeRow.update(
                items <- items + "," + item
            ))

        } catch {
            print("Update failed: \(error)")
            return false
        }
        /*
        do {
            for place in try database.prepare(placeRow) {
                let updatedItems = place[items] + "," + item
                
                print("updatedItems " + updatedItems)
                print("place " + String(describing: place))
                
                //Update the place's items list.
                do {
                    try database.run(placeRow.update(name <- "E", items <- updatedItems, key <- "E"))
                    print("Added")
                    return true
                    
                } catch {
                    print(error.localizedDescription)
                    return false
                }
            }
        } catch {
            print("Present row error: \(error)")
            return false
        }*/
        print("Added")
        print("New row \(presentRows(placeRow))")
        return true
    }
    
    static func presentRows() -> [Place]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var placesArray = [Place]()
        
        table = table.order(key.desc)
        
        do {
            for place in try database.prepare(table) {
                let nameValue = place[name]
                let itemsValue = place[items]
                let keyValue = place[key]
                let placeObject = Place(name: nameValue, items: itemsValue, key: keyValue)
                
                placesArray.append(placeObject)
                print("name: \(place[name]), items: \(place[items]), key: \(place[key])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return placesArray
    }
    
    static func presentRows(_ table: Table) -> [Place]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var placesArray = [Place]()
        
        let newTable = table.order(key.desc)
        
        do {
            for place in try database.prepare(newTable) {
                let nameValue = place[name]
                let itemsValue = place[items]
                let keyValue = place[key]
                let placeObject = Place(name: nameValue, items: itemsValue, key: keyValue)
                
                placesArray.append(placeObject)
                print("name: \(place[name]), items: \(place[items]), key: \(place[key])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return placesArray
    }
    
    static func convertDatabaseToDictionary() -> [String:Place]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        var placesDict = [String:Place]()
        
        table = table.order(key.desc)
        
        do {
            for place in try database.prepare(table) {
                let nameValue = place[name]
                let itemsValue = place[items]
                let keyValue = place[key]
                let placeObject = Place(name: nameValue, items: itemsValue, key: keyValue)
                
                placesDict[keyValue] = placeObject
                //placesDict.append(placeObject)
                //print("name: \(place[name]), items: \(place[items]), key: \(place[key])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        return placesDict
    }
}
