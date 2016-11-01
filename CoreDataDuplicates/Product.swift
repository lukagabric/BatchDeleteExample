//
//  Product.swift
//  CoreDataDuplicates
//
//  Created by Luka Gabric on 01/11/2016.
//  Copyright © 2016 PROGOS. All rights reserved.
//

import UIKit
import CoreData

@objc(Product)
class Product: NSManagedObject {
    
    override var description: String {
        return "\n\t\(self.productId!) \t \(self.productName!)"
    }

}
