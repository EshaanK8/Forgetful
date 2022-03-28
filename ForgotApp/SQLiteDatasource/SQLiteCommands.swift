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
        print("Added")
        print("New row \(presentRows(placeRow))")
        return true
    }
    
    static func removeItem(placeKey:String, item:String) -> Bool? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
        
        self.table = Table("place") //This is needed to avoid error
        let placeRow = self.table.filter(key == placeKey) //Get the row of the place we want to change
        //print("Items: \(presentRows(placeRow))")
        //print("newItems:" + replacingFirstOccurrence(input: item, target: "," + item, replacement: ""))
        //Process the string into an array, remove the element, then process it back into a string
        //var itemsArray = items.template.split(separator: ",")
        print("Item is " + item)
        var itemsArray = presentItems(placeRow)
        print(itemsArray)
        itemsArray.remove(at: itemsArray.firstIndex(of: item)!)
        var itemsString = itemsArray.joined(separator:",")
        
        do {
            try database.run(placeRow.update(
                items <- itemsString
            ))
        } catch {
            print("Update failed: \(error)")
            return false
        }
        print("Removed")
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
    
    static func presentItems(_ table: Table) -> [String] {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return [String]()
        }
        
        var itemsArray = [String]()
        
        SQLiteCommands.table = table.order(key.desc)
        
        do {
            for place in try database.prepare(table) {
                let itemsValue = place[items].split(separator: ",")
                
                for item in itemsValue {
                    itemsArray.append(String(item))
                }
            }
        } catch {
            print("Present row error: \(error)")
        }
        return itemsArray
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
            }
        } catch {
            print("Present row error: \(error)")
        }
        return placesDict
    }
    
    static func replacingFirstOccurrence(input: String, target: String, replacement: String) -> String {
        guard let range = input.range(of: target) else { return input }
        return input.replacingCharacters(in: range, with: replacement)
    }
}

