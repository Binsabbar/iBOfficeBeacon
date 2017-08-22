//
//  AppColours.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 30/12/2015.
//  Copyright © 2015 Binsabbar. All rights reserved.
//

import UIKit

class AppColours {
    
    static var lightGrey = UIColor.RGBColor(red:219, green: 218, blue: 222)
    static var grey = UIColor.RGBColor(red: 141, green: 144, blue: 147)
    static var mediumGrey = UIColor.RGBColor(red: 115, green: 118, blue: 130)
    static var darkGrey = UIColor.RGBColor(red: 29, green: 28, blue: 32)
    static var darkestGrey = UIColor.RGBColor(red: 15, green: 14, blue: 18)
    
    static var lightBlue = UIColor.RGBColor(red: 0, green: 136, blue: 2015)
    static var blue = UIColor.RGBColor(red: 0, green: 115, blue: 182)
    static var darkBlue  = UIColor.RGBColor(red: 35, green: 57, blue: 129)
    
    static var red = UIColor.RGBColor(red: 159, green: 7, blue: 18)
    static var darkRed = UIColor.RGBColor(red: 64, green: 0, blue: 0)
    static var mediumRed = UIColor.RGBColor(red: 140, green: 0, blue: 0)
    //255, 40, 40
    static var lightRed = UIColor.RGBColor(red: 255, green: 40, blue: 40)
    
    static var green = UIColor.RGBColor(red: 0, green: 106, blue: 18)
    
    static var lightGreen = UIColor.RGBColor(red: 0, green: 191, blue: 143)
    static var mediumGreen = UIColor.RGBColor(red: 0, green: 98, blue: 74)
    static var darkGreen = UIColor.RGBColor(red: 0, green: 47, blue: 35)

}

extension UIColor {
    
    class func RGBColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}


