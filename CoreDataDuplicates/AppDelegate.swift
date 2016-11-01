//
//  AppDelegate.swift
//  CoreDataDuplicates
//
//  Created by Luka Gabric on 31/10/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.runDeleteSample()
        return true
    }
    
    func runDeleteSample() {
        self.persistentContainer.performBackgroundTask { context in
            //just cleanup the database
            self.deleteAllObjects(context: context)
            
            //Simulates a random number of duplicates (objects with the same productId), that can be distinguished by the productName
            //e.g. one product could have    productId = "id.1" and productName = "Product 1.1",
            //and a duplicate will also have productId = "id.1" but productName = "Product 1.2"
            self.insertDuplicates(context: context)
            try! context.save()
            
            //prints all duplicates from the view context
            self.refreshAndPrintProducts()
            
            //removes all duplicates
            self.deleteDuplicates(context: context)
            try! context.save()
            
            //prints all unique objects
            self.refreshAndPrintProducts()
        }
    }
    
    func deleteAllObjects(context: NSManagedObjectContext) {
        let productsRequest = Product.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: productsRequest)
        deleteRequest.resultType = .resultTypeCount
        let duplicateObjects = try! context.execute(deleteRequest) as! NSBatchDeleteResult
        let deletedObjectsCount = duplicateObjects.result as! Int
        print("Deleted objects count: \(deletedObjectsCount)")
    }
    
    func insertDuplicates(context: NSManagedObjectContext) {
        let uniqueProductsCount = 4
        var productsCount = 0
        
        for objectId in 1...uniqueProductsCount {
            for ordinal in 1...4 + Int(arc4random_uniform(6)) {
                let product = Product(context: context)
                product.productId = "id.\(objectId)"
                product.productName = "Product \(objectId).\(ordinal)"
                productsCount += 1
            }
        }
        
        print("Inserted \(productsCount) objects (\(uniqueProductsCount) unique, \(productsCount - uniqueProductsCount) are duplicates that should be deleted)")
    }
    
    func deleteDuplicates(context: NSManagedObjectContext) {
        let duplicatesRequest = NSBatchDeleteRequest(fetchRequest: self.duplicatesFetchRequest(context: context))
        duplicatesRequest.resultType = .resultTypeCount
        
        let duplicateObjects = try! context.execute(duplicatesRequest) as! NSBatchDeleteResult
        let deletedObjectsCount = duplicateObjects.result as! Int
        print("Deleted duplicate objects count: \(deletedObjectsCount)")
    }
    
    func duplicatesFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult> {
        let productsToKeepRequest = Product.fetchRequest() as NSFetchRequest<Product>
        
        //Object IDs of products to keep
        let expressionDescription = NSExpressionDescription()
        expressionDescription.expression = NSExpression.expressionForEvaluatedObject()
        expressionDescription.name = "fetchedObjectId"
        expressionDescription.expressionResultType = .objectIDAttributeType
        
        productsToKeepRequest.propertiesToFetch = [expressionDescription]
        productsToKeepRequest.propertiesToGroupBy = ["productId"]
        productsToKeepRequest.resultType = .dictionaryResultType
        //predicate to determin the objects to keep
        productsToKeepRequest.predicate = NSPredicate(format: "%K contains %@", "productName", ".1")
        
        //all objects except objectsToKeepRequest are duplicates
        let productsToKeepExpression = NSFetchRequestExpression.expression(forFetch: NSExpression(forConstantValue: productsToKeepRequest),
                                                                           context: NSExpression(forConstantValue: context),
                                                                           countOnly: false)
        
        let duplicatesRequest = Product.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        duplicatesRequest.predicate = NSPredicate(format: "NOT SELF IN %@", argumentArray: [productsToKeepExpression])
        
        return duplicatesRequest
    }
    
    func refreshAndPrintProducts() {
        //For this sample I'm just printing objects to console, but viewContext (associated with the main queue) is used
        //so you'd be able to use the fetched products for binding to UI (e.g. in a UITableView)
        let context = self.persistentContainer.viewContext
        context.performAndWait {
            let productsRequest = Product.fetchRequest() as NSFetchRequest<Product>
            let sort = NSSortDescriptor(key: "productName", ascending: true)
            productsRequest.sortDescriptors = [sort]
            let products = try! context.fetch(productsRequest)
            
            print(products)
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataDuplicates")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: -
    
}
