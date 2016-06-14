//
//  CommentModel.swift
//  youbike
//
//  Created by howard hsien on 2016/5/20.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import Alamofire

struct Comment{
    let userName:String
    let userPicUrl:String
    let text:String
    let createdTime:String
}
class CommentModel {
    var comments: [Comment]{
        return _comments
    }
    var ID: String{
        return _ID
    }
    private var _ID = ""
    private var _comments : [Comment] = []
    private var _nextPage:String?
    private var _previousPage:String?
    //ARC
    weak var internetDelegate:InternetDelegate?
    let commentURL = "http://139.162.32.152:3000/stations/%@/comments"
    let commentURL_withPaging = "http://139.162.32.152:3000/stations/%@/comments?paging=%@"

    
    
    //MARK:handle ID Control
    //checkID and reset the ID
    //when resetting the ID -> clear all the comments
    func checkID(newID:String) -> Bool{
        if newID == ID{
            return true
        }
        else{
            return false
        }
    }
    
    func resetID(newID:String) {
        _ID = newID
        clearComments()
    }
    
    
    
    func addComment(newComment: Comment){
        _comments.append(newComment)
    }
    
    func clearComments() {
        _comments.removeAll()
        _nextPage = nil
        _previousPage = nil
    }

    
//MARK: Data Handling
    
//get data Alamofire request and use JWT for classifying
    
    private func getCommentDataWithCompletionHandlerAndJWT(urlPath: String,  completion:()->Void) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0) ){
            guard let JWTToken = self.internetDelegate?.generateJWTToken()
                else{
                    print("[CommentModel](getCommentDataWithCompletionHandlerAndJWT) JWT token is nil")
                    return
            }
            Alamofire.request(
                .GET,
                urlPath,
                headers:["Authorization":"Bearer \(JWTToken)"]
                ).validate() //only statusCode between 200 - 299 is acceptable
                .responseJSON{
                    response in
                    guard response.result.isSuccess else{
                        print("[CommentModel](getCommentDataWithCompletionHandlerAndJWT) can't get data from server")
                        print("[CommentModel](getCommentDataWithCompletionHandlerAndJWT) statusCode:\(response.response?.statusCode)")
                        print("[CommentModel](getCommentDataWithCompletionHandlerAndJWT) error:\(response.result.error)")
                        return
                    }
                    
                    self.parseCommentJSON(response.result.value!)
                    dispatch_async(dispatch_get_main_queue()){
                        completion()
                        
                    }
            }
        }
    }
    func getCommentData( ID:String, completion: ()->Void){
        if !checkID(ID){
            resetID(ID)
        }
   //     print("[CommentModel](getCommentData) nextPageString:\(_nextPage)")
        if let nextPage = self._nextPage{
            guard let url = NSString(format: commentURL_withPaging, _ID, nextPage) as? String else { return }
            getCommentDataWithCompletionHandlerAndJWT(url, completion: completion)
        }else if comments.isEmpty{
            guard let url = NSString(format: commentURL, _ID) as? String else { return }
            getCommentDataWithCompletionHandlerAndJWT(url, completion: completion)
            completion()
        }
        else{
            //if the comments are not empty and no nextpage-> it indicates that there is no nore comments
            completion()
        }
    }

//    func getNextCommentPageData( ID:String, completion: ()->Void){
//        print("[StationModel](getNextStationPageData) nextPageString:\(_nextPage)")
//        if let nextPage = self._nextPage{
//            getYoubikeDataWithCompletionHandlerAndJWT(commentURL+ID-"?paging="+nextPage, completion: completion)
//        }else{
//            completion()
//        }
//    }
    
    
    
    //MARK: parse data
    func parseCommentJSON(jsonObject : AnyObject){
        
        //     let resultFromJSON = jsonObject["result"] as! [String:AnyObject]
        
        guard let results = jsonObject["data"] as?[[String:AnyObject]]
            else{ return }
        
        //before saving data into coreData -> clearCoreData first
        
        for result in results{
            let userName:String
            let userPicUrl:String
            let text:String
            let createdTime:String
           
            text = result["text"] as! String
            
            if let user = result["user"] as? [String:AnyObject]{
                userName = user["name"] as! String
                userPicUrl = user["picture"] as! String
            }
            else{
                userName = ""
                userPicUrl = ""
                print("[CommentModel](parseCommentJSON)user is nil")
            }
            createdTime = result["created"] as! String
            _comments.append(
                Comment(
                    userName: userName,
                    userPicUrl: userPicUrl,
                    text:text,
                    createdTime:createdTime))
//            //try to save in core data
//            saveInCoreData(
//                youbikeLocation: stationName,
//                youbikeAreas: stationAddress,
//                youbikeRemaining: stationBikes,
//                stationLongitude: stationLng,
//                stationLatitude: stationLat)
            
        }
        guard let paging = jsonObject["paging"] as? [String:AnyObject] else{
            print("[StationModel](parseJSON) no paging return")
            return
        }
        
        _nextPage = (paging["next"] as? String) ?? nil
        _previousPage = (paging["previous"] as? String) ?? nil
    }

    
}