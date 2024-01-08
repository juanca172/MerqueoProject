//
//  CoreDataStack.swift
//  MerqueoUIKit
//
//  Created by Juan Camilo Fonseca Gomez on 7/01/24.
//

import Foundation
import CoreData
protocol CoreDataStackProtocol {
    func save()
    var managedContext: NSManagedObjectContext { get }
}
final class CoreDataStack: CoreDataStackProtocol {
    private let container: NSPersistentContainer!
    lazy var managedContext: NSManagedObjectContext = container.viewContext
    init() {
        container = NSPersistentContainer(name: "MovieCoreData")
        setUpCoreData()
        save()
    }
    private func setUpCoreData() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading store \(error)")
                return
            }
            print("Database ready!")
        }
    }
    private func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    func save() {
        saveContext()
    }
    
}
