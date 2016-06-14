//
//  ImageDownloader.swift
//  youbike
//
//  Created by howard hsien on 2016/5/22.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation

class ImageDownloader {
    static var _instance = ImageDownloader()
    class func sharedInstance() ->ImageDownloader{
        return _instance
    }
    
    typealias Completion = (data:NSData?)->Void
    //MARK: load Image
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImageWithCompletionHandler(url: NSURL, completion: Completion){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else {
                    print(error)
                    return }
                //                print(response?.suggestedFilename ?? "")
//                self.profileImage.image = UIImage(data: data)
                completion(data: data)
            }
        }
    }
}