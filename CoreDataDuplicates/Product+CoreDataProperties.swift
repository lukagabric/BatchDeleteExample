//
//  Product+CoreDataProperties.swift
//  CoreDataDuplicates
//
//  Created by Luka Gabric on 31/10/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product");
    }

    @NSManaged public var productId: String?
    @NSManaged public var productName: String?
    
}
