//
//  Station+CoreDataProperties.swift
//  
//
//  Created by howard hsien on 2016/5/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Station {

    @NSManaged var stationName: String?
    @NSManaged var stationAddress: String?
    @NSManaged var stationLongitude: NSNumber?
    @NSManaged var stationLatitude: NSNumber?
    @NSManaged var remainingBikes: NSNumber?
    @NSManaged var stationID: String?

}
