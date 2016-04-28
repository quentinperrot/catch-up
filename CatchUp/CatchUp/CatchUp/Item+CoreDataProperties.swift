//
//  Item+CoreDataProperties.swift
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

extension Item {

    @NSManaged var authorName: String?
    @NSManaged var date: String?
    @NSManaged var id: String?
    @NSManaged var link: String?
    @NSManaged var title: String?
    @NSManaged var viewedStatus: NSNumber?
    @NSManaged var sectionOwner: Section?

}
