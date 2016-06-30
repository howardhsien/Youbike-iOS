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


class StationModel {

    var youbikeURL = "http://139.162.32.152:3000/stations"
    var language :String
    let dataController = (UIApplication.sharedApplication().delegate as! AppDelegate).dataController
    //ARC
    weak var internetDelegate:InternetDelegate?
    let managedObjectContext : NSManagedObjectContext
    let persistentStoreCoordinator : NSPersistentStoreCoordinator

    private var _stations = [YoubikeStation]()
    private var _nextPage:String?
    private var _previousPage:String?
    var stations : [YoubikeStation] {return _stations}

    
    init(){
        language = NSLocale.preferredLanguages()[0]
        managedObjectContext = dataController.managedObjectContext
        persistentStoreCoordinator = dataController.persistentStoreCoordinator
        


    }
    
//MARK: RESFUL API get from Internet

     //get data Alamofire request and use JWT for classifying
    func getYoubikeDataWithCompletionHandlerAndJWT(urlPath: String, completion:()->Void) {
       
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ){
            guard let JWTToken = self.internetDelegate?.generateJWTToken                ()
            else{
                print("[StationModel](getYoubikeDataWithCompletionHandlerAndJWT) JWT token is nil")
                return
            }
            Alamofire.request(
                .GET,
                urlPath,
                headers:["Authorization":"Bearer \(JWTToken)"]
                ).responseJSON{
                response in
                    print("has response")
                guard response.result.isSuccess else{
                    print("[StationModel](getYoubikeDataWithCompletionHandlerAndJWT) can't get data from server")
                    print("[StationModel](getYoubikeDataWithCompletionHandlerAndJWT) statusCode:\(response.response?.statusCode)")
                    print("[StationModel](getYoubikeDataWithCompletionHandlerAndJWT) error:\(response.result.error)")
                    self.fetchFromCoreData(completion)
                    return
                }
                self.parseStationJSON(response.result.value!)
                dispatch_async(dispatch_get_main_queue()){
                    completion()
                   
                }
            }
        }
     
    }
    
    func getNextStationPageData(completion: ()->Void){
        print("[StationModel](getNextStationPageData) nextPageString:\(_nextPage)")
        if let nextPage = self._nextPage{
            getYoubikeDataWithCompletionHandlerAndJWT(youbikeURL+"?paging="+nextPage, completion: completion)
        }else{
            completion()
        }
    }

  
    
    //MARK: parse data
    func parseStationJSON(jsonObject : AnyObject){

   //     let resultFromJSON = jsonObject["result"] as! [String:AnyObject]
        
        guard let results = jsonObject["data"] as?[[String:AnyObject]]
            else{ return }
        
        //before saving data into coreData -> clearCoreData first
        clearCoreData()
        
        for result in results{
            let stationName:String
            let stationAddress:String
            if(self.language == "zh-Hant-US" ){
                stationName = result["sna"] as! String
                stationAddress = result["ar"] as! String
            }
            else{
                stationName = result["snaen"] as! String
                stationAddress = result["aren"] as! String
            }
            let stationBikes = Int(result["sbi"] as! String)!
            let stationLng = Double(result["lng"] as! String)!
            let stationLat = Double(result["lat"] as! String)!
            let stationID = result["sno"] as! String
            //print result of sno is to check where are we loading
            //          print(result["sno"])
            _stations.append(
                YoubikeStation(
                    youbikeLocation: stationName,
                    youbikeAreas: stationAddress,
                    youbikeRemaining: stationBikes,
                    stationLongitude: stationLng,
                    stationLatitude: stationLat,
                    stationID: stationID))
            //try to save in core data
            saveInCoreData(
                youbikeLocation: stationName,
                youbikeAreas: stationAddress,
                youbikeRemaining: stationBikes,
                stationLongitude: stationLng,
                stationLatitude: stationLat,
                stationID: stationID)
            
        }
        guard let paging = jsonObject["paging"] as? [String:AnyObject] else{
            print("[StationModel](parseJSON) no paging return")
            return
        }

        _nextPage = (paging["next"] as? String) ?? nil
        _previousPage = (paging["previous"] as? String) ?? nil
    }
}



//MARK: CRUD in CoreData
extension StationModel {
    //fetch data from core data
    func fetchFromCoreData(completion:() -> Void){
        print("[StationModel] (fetchFromCoreData) It seems like there is some Internet Problem. Now we load data from core data.")
        
        let stationFetch = NSFetchRequest(entityName: "Station")
        do{
            let fetchedStation = try managedObjectContext.executeFetchRequest(stationFetch) as! [Station]
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
            print("[StationModel] (fetchFromCoreData) fetch has some problem-> error:\(error)")
        }
        dispatch_async(dispatch_get_main_queue()){
            completion()
        }
        
    }
    //clear core data
    func clearCoreData() {
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
                        stationID: String){
        //Station is the type of entity
        let entity = NSEntityDescription.insertNewObjectForEntityForName("Station", inManagedObjectContext: managedObjectContext) as! Station
        entity.setValue(youbikeLocation, forKey: "stationName")
        entity.setValue(youbikeAreas, forKey: "stationAddress")
        entity.setValue(youbikeRemaining, forKey: "remainingBikes")
        entity.setValue(stationLongitude, forKey: "stationLongitude")
        entity.setValue(stationLatitude, forKey: "stationLatitude")
        entity.setValue(stationID, forKey: "stationID")
        do{
            try managedObjectContext.save()
            
        }catch{
            fatalError("[StationModel] (saveInCoreData) failure to save context-> error:\(error)")
        }
        
    }

    
}



//original version of http request
extension StationModel {

    func httpGet(urlPath : String){
        let urlPath: String = urlPath
        let requestURL: NSURL = NSURL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            guard let httpResponse = response as? NSHTTPURLResponse else{
                print("response failed")
                return
            }
            let statusCode = httpResponse.statusCode
            guard let data = data else {
                print("data nil")
                return
            }
            if (statusCode == 200) {
                do{
                    print("get succeed")
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options:.AllowFragments)
                    self.parseStationJSON(jsonObject)
                    
                }
                catch let error{
                    print(error)
                }
            }

        }
        task.resume()
        
    }
    
    //make http post to certain url
    func httpPost(data : Dictionary<String, AnyObject> ,url: String) {
        let session = NSURLSession.sharedSession()
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!)
        urlRequest.HTTPMethod = "POST"
        
        do{
            try urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(data, options: [] )
        }
        catch let err{ print(err)}
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { ( data, response, error)->Void in
            print("data:\(data)")
            print("response:\(response)")
            print("error:\(error)")
        })
        task.resume()
    }
    
}