//
//  YoubikeManager.swift
//  youbike
//
//  Created by howard hsien on 2016/5/3.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation


class YoubikeManager  :BaseManager,CLLocationManagerDelegate{
    static var _instance : YoubikeManager?
    var stationModel = StationModel()
    var commentModel = CommentModel()
    private var youbikeStationURL = ["http://data.taipei/youbike"]
    private var locationManager = CLLocationManager()
    private var coreDataManager = CoreDataManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    class func sharedInstance() ->YoubikeManager{
        if _instance == nil{
            _instance = YoubikeManager()
        }
        return _instance!
    }
    
    func getYoubikeDataWithCompletionHandler( completion:()->Void ) -> Request? {
        print(classDebugInfo+#function)
        guard let urlPath = youbikeStationURL.first else { return nil}
        var request :Request?
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ){
            request =  Alamofire.request(
                .GET,
                urlPath
                ).responseJSON{
                    response in
                    print("has response")
                    //error handling
                    guard response.result.isSuccess else{
                        print(self.classDebugInfo+#function+" can't get data from server")
                        print(self.classDebugInfo+#function+" statusCode:\(response.response?.statusCode)")
                        print(self.classDebugInfo+#function+" error:\(response.result.error)")
                        return
                    }
                    if let jsonObject = response.result.value{
                        self.coreDataManager.clearCoreData()
                        self.stationModel.parseStationJSON(jsonObject)
                        self.calculateDistanceAndSave(stations : self.stationModel.stations)
                        self.stationModel.setStations(self.coreDataManager.fetchStationsFromCoreData())
                    }
                    dispatch_async(dispatch_get_main_queue()){
                        completion()
                        print(self.classDebugInfo+"completion")
  
                    }
            }
        }
        return request
    }
    
    private func calculateDistanceAndSave(stations stations: [YoubikeStation]){
        for station in stations{
//            print(station.youbikeLocation)
            let stationLocation = CLLocation(latitude: station.stationLatitude,longitude: station.stationLongitude)
            if let distanceFromSelf = locationManager.location?.distanceFromLocation(stationLocation)
            {
                coreDataManager.saveInCoreData(
                    youbikeLocation: station.youbikeLocation,
                    youbikeAreas: station.youbikeAreas,
                    youbikeRemaining: station.youbikeRemaining,
                    stationLongitude: station.stationLongitude,
                    stationLatitude: station.stationLatitude,
                    stationID: station.stationID,
                    distance: distanceFromSelf)
            }
            else{
                print(#function + " can't get locationManager.location")
            }
           
        }
         print(#function + "after for")
        
    }

    
    
}