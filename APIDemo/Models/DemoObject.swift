//
//  DemoObject.swift
//  DemoAPI
//
//  Created by Rishabh Raj on 06/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//

import Foundation
import CoreData

public class DemoObject : NSManagedObject, Identifiable {
    @NSManaged public var id : Double
    @NSManaged public var name : String
    @NSManaged public var open_issues_count : Double
    @NSManaged public var license : String?
    @NSManaged public var permissions : Bool
    
    func update(with jsonDict : [String: Any]) throws {
        guard let id = jsonDict["id"] as? Double,
            let name = jsonDict["name"] as? String,
            let open_issues_count = jsonDict["open_issues_count"] as? Double,
            let licenseDict = jsonDict["license"] as? [String: Any],
            let permissionsDict = jsonDict["permissions"] as? [String : Any] else {
                throw NSError(domain: "JSONError",code: 100,userInfo: nil)
        }
        
        guard let licenseName = licenseDict["name"] as? String,
            let adminPerm = permissionsDict["admin"] as? Bool else{
                throw NSError(domain: "JSONError",code: 100,userInfo: nil)
        }
        
        self.id = id
        self.name = name
        self.open_issues_count = open_issues_count
        self.license = licenseName
        self.permissions = adminPerm
    }
}

class CoreDataStack {
    private init() { }
    
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DemoAPI")
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
}
