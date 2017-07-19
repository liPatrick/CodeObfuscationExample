//
//  Note+CoreDataClass.swift
//  NoteTaker
//
//  Created by Shane Doyle on 07/01/2017.
//  Copyright © 2017 Shane Doyle. All rights reserved.
//

import Foundation
import CoreData


public class Note: NSManagedObject {

    @NSManaged public var url: String
    @NSManaged public var name: Data
    
}
