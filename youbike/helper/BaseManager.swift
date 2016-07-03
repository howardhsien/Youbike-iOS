//
//  BaseManager.swift
//  youbike
//
//  Created by howard hsien on 2016/7/2.
//  Copyright © 2016年 AppWorks School Hsien. All rights reserved.
//

import Foundation


class BaseManager : NSObject{
    var classDebugInfo :String {
        return "[\(self.dynamicType)]"
    }
}