//
//  YoubikeManager.swift
//  youbike
//
//  Created by howard hsien on 2016/5/3.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation
import JWT

class YoubikeManager :InternetDelegate {
    static var _instance : YoubikeManager?
    var stationModel = StationModel()
    var commentModel = CommentModel()
    let ID:String
    
    init(){
        ID = NSUUID().UUIDString
        stationModel.internetDelegate = self
        commentModel.internetDelegate = self
                
    }
    class func sharedInstance() ->YoubikeManager{
        if _instance == nil{
            _instance = YoubikeManager()
        }
        return _instance!
    }
    
    
    //MARK: JWT
    //Generate JWT Token
    func generateJWTToken() ->String {
        let jwtEncode = JWT.encode(.HS256("appworks")) { builder in
            builder.issuer = "howard"
            builder.expiration = NSCalendar.currentCalendar().dateByAddingUnit(
                .Minute,
                value: 5,
                toDate: NSDate(),
                options: []
            )
        }
        print("[YoubikeManager](generateJWTToken) the token is:\(jwtEncode)")
        return jwtEncode
    }

}