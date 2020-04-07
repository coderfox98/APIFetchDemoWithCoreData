//
//  DemoObjectViewModel.swift
//  DemoAPI
//
//  Created by Rishabh Raj on 06/04/20.
//  Copyright © 2020 Rishabh Raj. All rights reserved.
//

import SwiftUI
import CoreData

class DemoObjectViewModel : ObservableObject {
    @Published var objects = [DemoObject]()
    
    var startIndex : Int { objects.startIndex }
    var endIndex : Int { objects.endIndex }
    
    var nextPageToLoad : Int = 1
    
    var curentlyLoading = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    init() {
        updateObjects()
    }
    
    func updateObjects(currentItem : DemoObject? = nil) {
        if !shouldLoadMoreData(currentItem: currentItem) { return }
        curentlyLoading = true
        
        WebService.shared.getObjects(for: nextPageToLoad, onSucess: { (objects) in
            self.clearStorage()
            self.save(objects: objects)
            self.objects.append(contentsOf: objects)
            self.nextPageToLoad += 1
            self.curentlyLoading = false
        }) { (error) in
            print(error)
            if let objList = self.fetchFromStorage() {
                DispatchQueue.main.async {
                    self.objects.append(contentsOf: objList)
                }
            }
        }
        
       
    }
    
    func shouldLoadMoreData(currentItem : DemoObject? = nil) -> Bool {
        if curentlyLoading {
            return false
        }
        guard let currentItem = currentItem else {
            return true
        }
        
        guard let lastItem = objects.last else {
            return false
        }
        
        
        if lastItem.id == currentItem.id {
            return true
        }
        
        return false
    }
  
}

extension DemoObjectViewModel  {
    private func clearStorage() {
               let isInMemoryStore = appDelegate.persistentContainer.persistentStoreDescriptions.reduce(false) {
                   return $0 ? true : $1.type == NSInMemoryStoreType
               }

               let managedContext = appDelegate.persistentContainer.viewContext
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DemoObjectCD")
               if isInMemoryStore {
                   do {
                       let users = try managedContext.fetch(fetchRequest)
                       for user in users {
                           managedContext.delete(user as! NSManagedObject)
                       }
                   } catch let error as NSError {
                       print(error)
                   }
               } else {
                   let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                   do {
                       try managedContext.execute(batchDeleteRequest)
                   } catch let error as NSError {
                       print(error)
                   }
               }
    }
    
    private func fetchFromStorage() -> [DemoObject]? {
       
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DemoObjectCD")
        let sortDescriptor1 = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sortDescriptor1]
        request.returnsObjectsAsFaults = false
        do {
            let objs = try managedContext.fetch(request)
            let objCodable = getObjFromAny(objs as! [NSManagedObject])
            return objCodable
        }catch {
            print(error)
            return nil
        }
    }
    
    private func save(objects : [DemoObject]) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let objEntity = NSEntityDescription.entity(forEntityName: "DemoObjectCD", in: managedContext)!
        
        for obj in objects {
            let objCD = NSManagedObject(entity: objEntity, insertInto: managedContext)
            objCD.setValue(obj.id, forKey: "id")
            objCD.setValue(obj.description, forKey: "description_a")
            objCD.setValue(obj.name, forKey: "name")
            objCD.setValue(obj.open_issues_count, forKey: "open_issues_count")
            objCD.setValue(obj.license?.key, forKey: "license_key")
            objCD.setValue(obj.permissions?.admin, forKey: "permissions_admin")
        }

        do {
            try managedContext.save()
        }catch {
            print("Unable to save\(error)")
        }
        
    }
    
    func getObjFromAny(_ moArray : [NSManagedObject]) -> [DemoObject] {
        var objs = [DemoObject]()
        
        for managedObject in moArray {
            
            let name = managedObject.value(forKey: "name") as? String
            let description = managedObject.value(forKey: "description_a") as? String
            let id = managedObject.value(forKey: "id") as? Double
            let open_issues_count = managedObject.value(forKey: "open_issues_count") as? Double
            let permAdmin = managedObject.value(forKey: "permissions_admin") as? Bool
            let licenseKey = managedObject.value(forKey: "license_key") as? String
            
            let obj = DemoObject(id: id, name: name, description: description, open_issues_count: open_issues_count, license: .init(key: licenseKey), permissions: .init(admin: permAdmin))
            objs.append(obj)
            
        }
        return objs
        
    }
}
