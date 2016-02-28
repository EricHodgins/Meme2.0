//
//  MemeModel.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Meme : NSManagedObject {
    
    @NSManaged var topTextField: String
    @NSManaged var bottomTextField: String
    @NSManaged var image: NSData
    @NSManaged var memedImage: NSData
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(top : String, bottom: String, orginalImage: NSData, memedNewImage: NSData, context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        topTextField = top
        bottomTextField = bottom
        image = orginalImage
        memedImage = memedNewImage
    }
    
}