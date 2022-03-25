//
//  SQLiteDatabase.swift
//  ForgotApp
//
//  Created by Eshaan Kunchur on 2022-03-22.
//

import Foundation
import SQLite

class SQLiteDatabase {
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("itemsList").appendingPathExtension("sqlite3")
            
            database = try Connection(fileURL.path)
        } catch {
            print("There was an error while creating a connection to the database: \(error)")
        }
    }
    
    func createTable() {
        SQLiteCommands.createTable()
    }
    
}
