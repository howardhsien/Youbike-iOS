//
//  CoreDataManager.swift
//  youbike
//
//  Created by howard hsien on 2016/7/2.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager :BaseManager {
    let dataController = DataController()
    var managedObjectContext :NSManagedObjectContext {
        return dataController.managedObjectContext
    }
    var persistentStoreCoordinator : NSPersistentStoreCoordinator {
        return dataController.persistentStoreCoordinator
    }
    
    //fetch data from core data
    func fetchStationsFromCoreData()-> [YoubikeStation]{
        print(classDebugInfo + #function)
        var _stations = [YoubikeStation]()
        let descriptor = NSSortDescriptor(key: "distanceFromSelf", ascending: true)
        let stationFetch = NSFetchRequest(entityName: "Station")
        stationFetch.sortDescriptors = [descriptor]
        managedObjectContext.performBlockAndWait{
        do{
            let fetchedStation = try self.managedObjectContext.executeFetchRequest(stationFetch) as! [Station]
            print("fetchStation.count: \(fetchedStation.count)")
            for station in fetchedStation{
                guard let name = station.stationName,
                    address = station.stationAddress,
                    remaining = station.remainingBikes,
                    longitude = station.stationLongitude,
                    latitude = station.stationLatitude,
                    stationID = station.stationID
                    else{
                        continue
                }
                print(#function + name)
//                print(station.distanceFromSelf)
                _stations.append(
                    YoubikeStation(
                        youbikeLocation: name,
                        youbikeAreas: address,
                        youbikeRemaining: Int(remaining),
                        stationLongitude: Double(longitude),
                        stationLatitude: Double(latitude),
                        stationID: stationID))
                
                }
        }catch{
            print(self.classDebugInfo + #function + "fetch has some problem-> error:\(error)")
            }}
        return _stations
        
    }
    //clear core data
    func clearCoreData() {
        print(classDebugInfo + #function)
        let fetchRequest = NSFetchRequest(entityName: "Station")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.persistentStoreCoordinator.executeRequest(deleteRequest, withContext: self.managedObjectContext)
        } catch let error as NSError {
            debugPrint("[StationModel] (clearCoreData) failure to clear coreData-> error:\(error)")
        }
    }
    
    //save data in core data
    func saveInCoreData(
        youbikeLocation youbikeLocation: String,
                        youbikeAreas: String,
                        youbikeRemaining: Int,
                        stationLongitude: Double,
                        stationLatitude: Double,
                        stationID: String,
                        distance: Double){
        
        print(classDebugInfo + #function)
        managedObjectContext.performBlockAndWait{
            //Station is the type of entity
            let entity = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: self.managedObjectContext) as! Station
            entity.setValue(youbikeLocation, forKey: "stationName")
            entity.setValue(youbikeAreas, forKey: "stationAddress")
            entity.setValue(youbikeRemaining, forKey: "remainingBikes")
            entity.setValue(stationLongitude, forKey: "stationLongitude")
            entity.setValue(stationLatitude, forKey: "stationLatitude")
            entity.setValue(stationID, forKey: "stationID")
            entity.setValue(distance, forKey: "distanceFromSelf")
//            print(self.classDebugInfo + youbikeLocation)
            do{
                try self.managedObjectContext.save()
                
            }catch{
                fatalError("[StationModel] (saveInCoreData) failure to save context-> error:\(error)")
            }
        }
        
    }
}
