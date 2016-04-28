//
//  Section+CoreDataProperties.swift
//  CatchUp
//
//  Created by Quentin Perrot on 4/27/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Section {

    @NSManaged var feedLink: String?
    @NSManaged var information: String?
    @NSManaged var name: String?
    @NSManaged var items: NSSet?

}
