//
//  DataStoreManager.swift
//  appHUDRit
//
//  Created by Maxorax on 24.03.2021.
//

import Foundation
import CoreData
class DataStoreManager{
    
    // MARK: - Core Data stack

    lazy var viewContext: NSManagedObjectContext = persistentContainer.viewContext

    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "appHUDRit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func obtainLastState() -> LastState? {
        
        if let lastOfStates = try? viewContext.fetch(LastState.fetchRequest()) as? [LastState], !lastOfStates.isEmpty  {
            return lastOfStates.last
        } else { return nil }
    }
    
    func SaveLastState(distance: Double , mSys: String, koef: Double, isHUDOn: Bool){
        let lastState = LastState(context: viewContext)
        lastState.distance = distance
        lastState.isHUDOn = isHUDOn
        lastState.koef = koef
        lastState.mSys = mSys
        do {
            try viewContext.save()
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
