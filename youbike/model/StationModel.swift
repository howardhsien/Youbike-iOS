//
//  StationModel.swift
//  week_3_part_5
//
//  Created by howard hsien on 2016/4/27.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Alamofire
import JWT
import CoreData
import CoreLocation

struct YoubikeStation {
    let youbikeLocation: String
    let youbikeAreas: String
    var youbikeRemaining: Int
    var stationLongitude :Double
    var stationLatitude : Double
    var stationID: String
}
protocol InternetDelegate: class {
    func generateJWTToken() ->String
}


class StationModel :NSObject,CLLocationManagerDelegate{

    
    var language :String?
    let dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
    //ARC
    weak var internetDelegate:InternetDelegate?
    var managedObjectContext : NSManagedObjectContext?
    var persistentStoreCoordinator : NSPersistentStoreCoordinator?

    private var _stations = [YoubikeStation]()
    var stations : [YoubikeStation] {return _stations}
    
    
    override init(){
        super.init()
        language = NSLocale.preferredLanguages()[0]
        managedObjectContext = dataController.managedObjectContext
        persistentStoreCoordinator = dataController.persistentStoreCoordinator

        


    }
    
    func setStations (stations: [YoubikeStation]){
        self._stations = stations
    }
    
    func clearStations(){
        self._stations.removeAll()
    }
        


  
    enum StationJsonError : ErrorType {
        case StationNameError
        case StationAddressError
        case StationIdError
        case StationLongitudeGetError
        case StationLongitudeCastDoubleError
        case StationLatitudeGetError
        case StationLatitudeCastDoubleError
        case StationBikeLeftGetError
        case StationBikeLeftCastIntError
    }
    
    
    //MARK: parse data
    func parseStationJSON(jsonObject : AnyObject){
         guard let results = jsonObject["retVal"] as?[String:[String:AnyObject]] else { print(#function+":retVal failed") ; return }
        //before saving data into coreData -> clearCoreData first

        for result_dict in results{
            let result = result_dict.1
            let stationName_tmp:AnyObject?
            let stationAddress_tmp:AnyObject?
            if(self.language == "zh-Hant-US" ){
                stationName_tmp = result["sna"]
                stationAddress_tmp = result["ar"]
            }
            else{
                stationName_tmp = result["snaen"]
                stationAddress_tmp = result["aren"]
            }
            guard let stationName = stationName_tmp as? String else { print(StationJsonError.StationNameError); return }
            guard let stationAddress = stationAddress_tmp as? String else { print(StationJsonError.StationAddressError); return }
            guard let stationID = result["sno"] as? String else { print(StationJsonError.StationIdError) ; return }
            
            //get data
            guard let longitude_str = result["lng"]  else{ print(StationJsonError.StationLongitudeGetError) ; return }
            guard let latitude_str = result["lat"]  else{ print(StationJsonError.StationLatitudeGetError) ; return }
            guard let bikeLeft_str = result["sbi"] else{ print(StationJsonError.StationBikeLeftGetError) ; return }
            //cast to certain data type
            guard let stationLng = Double(String(longitude_str)) else { print(StationJsonError.StationLongitudeCastDoubleError) ; return  }
            guard let stationLat = Double(String(latitude_str)) else { print(StationJsonError.StationLatitudeCastDoubleError) ; return  }
            guard let stationBikesLeft = Int(String(bikeLeft_str)) else { print(StationJsonError.StationBikeLeftGetError); return }
            
            

            //print result of sno is to check where are we loading
            //          print(result["sno"])
            _stations.append(
                YoubikeStation(
                    youbikeLocation: stationName,
                    youbikeAreas: stationAddress,
                    youbikeRemaining: stationBikesLeft,
                    stationLongitude: stationLng,
                    stationLatitude: stationLat,
                    stationID: stationID))
            //try to save in core data
//            saveInCoreData(
//                youbikeLocation: stationName,
//                youbikeAreas: stationAddress,
//                youbikeRemaining: stationBikes,
//                stationLongitude: stationLng,
//                stationLatitude: stationLat,
//                stationID: stationID)
//            
        }

    }
}



//MARK: CRUD in CoreData
extension StationModel {
  

    
}



//original version of http request
//extension StationModel {
//
//    func httpGet(urlPath : String){
//        let urlPath: String = urlPath
//        let requestURL: NSURL = NSURL(string: urlPath)!
//        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithRequest(urlRequest) {
//            (data, response, error) -> Void in
//            guard let httpResponse = response as? NSHTTPURLResponse else{
//                print("response failed")
//                return
//            }
//            let statusCode = httpResponse.statusCode
//            guard let data = data else {
//                print("data nil")
//                return
//            }
//            if (statusCode == 200) {
//                do{
//                    print("get succeed")
//                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
//                    self.parseStationJSON(jsonObject)
//                    
//                }
//                catch let error{
//                    print(error)
//                }
//            }
//
//        }
//        task.resume()
//        
//    }
//    
//    //make http post to certain url
//    func httpPost(data : Dictionary<String, AnyObject> ,url: String) {
//        let session = NSURLSession.sharedSession()
//        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
//        urlRequest.HTTPMethod = "POST"
//        
//        do{
//            try urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: [] )
//        }
//        catch let err{ print(err)}
//        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { ( data, response, error)->Void in
//            print("data:\(data)")
//            print("response:\(response)")
//            print("error:\(error)")
//        })
//        task.resume()
//    }
//    
//}