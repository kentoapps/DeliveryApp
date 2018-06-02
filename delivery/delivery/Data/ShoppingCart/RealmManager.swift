//
//  RealmManager.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import Realm
import RealmSwift
import RxSwift
import RxRealm

class RealmManager {
    
    private var database: Realm
    static let sharedInstance = RealmManager()
    
    internal required init() {
        database = try! Realm()
    }
    
    func getData(type: Object.Type) -> Results<Object>? {
        return database.objects(type)
    }
    
    func addData(object: Object)   {
        do {
            try! database.write {
                print("add: \(object)")
                database.add(object, update: true)
            }
        }
        catch let error as NSError {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }
    
    func updateData(object: Object)   {
        do {
            try! database.write {
                print("update: \(object)")
                database.add(object, update: true)
            }
        }
        catch let error as NSError {
            print("Something went wrong: \(error.localizedDescription)")
        }
    }
    
    
    func deleteAllFromDatabase()  {
        try!   database.write {
            database.deleteAll()
        }
    }
    
    func deleteFromDb(object: Object)   {
        try!   database.write {
            database.delete(object)
        }
    }
    
    func getNewId(type: Object.Type) -> Int? {
        
        let realm = try! Realm()
        var i = (realm.objects(type.self).max(ofProperty: "id") as Int? ?? 0) + 1
        return i
        
    }
}
