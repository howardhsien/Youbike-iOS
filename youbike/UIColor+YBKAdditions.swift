//
//  UIColor+YBKAdditions.swift
//  YouBike
//
//  Generated on Zeplin. (by howardhsien on 2016/4/26).
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

import UIKit

extension UIColor {
    class func ybkSandBrownColor() -> UIColor {
        return UIColor(red: 211.0 / 255.0, green: 150.0 / 255.0, blue: 104.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkBrownishColor() -> UIColor {
        return UIColor(red: 160.0 / 255.0, green: 98.0 / 255.0, blue: 90.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkDarkSandColor() -> UIColor {
        return UIColor(red: 166.0 / 255.0, green: 145.0 / 255.0, blue: 84.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkBarneyColor() -> UIColor {
        return UIColor(red: 201.0 / 255.0, green: 28.0 / 255.0, blue: 187.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkDarkSalmonColor() -> UIColor {
        return UIColor(red: 204.0 / 255.0, green: 113.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkCharcoalGreyColor() -> UIColor {
        return UIColor(red: 61.0 / 255.0, green: 52.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkPaleGoldColor() -> UIColor {
        return UIColor(red: 251.0 / 255.0, green: 197.0 / 255.0, blue: 111.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkWhiteColor() -> UIColor {
        return UIColor(white: 255.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkPaleColor() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 239.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
    }
    class func ybkDenimBlueColor() -> UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    
    class func ybkPaleTwoColor() -> UIColor {
        return UIColor(red: 254.0 / 255.0, green: 241.0 / 255.0, blue: 220.0 / 255.0, alpha: 1.0)
    }
    class func ybkPinkishGreyColor() -> UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }
}

extension UIFont {
    class func ybkTextStyleFont() -> UIFont? {
        return UIFont(name: "Helvetica-Bold", size: 80.0)
    }
    
    class func ybkTextStyle3Font() -> UIFont {
        return UIFont.systemFontOfSize(24.0, weight: UIFontWeightBold)
    }
    
    class func ybkTextStyle2Font() -> UIFont? {
        return UIFont(name: "PingFangTC-Medium", size: 20.0)
    }
    class func ybkTextStyleFBLoginButtonFont(size: CGFloat)-> UIFont?{
        return UIFont(name: "Helvetica", size: size)
    }
    class func ybkTextStyle4Font() -> UIFont {
        return UIFont.systemFontOfSize(10.0, weight: UIFontWeightRegular)
    }
}