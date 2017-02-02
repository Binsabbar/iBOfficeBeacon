//
//  g.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

class GradientLayer {
    
    var colorTop = UIColor(red: 23.0/255.0, green: 41.0/255.0, blue: 66.0/255.0, alpha: 1.0).CGColor
    var colorMiddle = UIColor(red: 24/255.0, green: 123/255.0, blue: 157/255.0, alpha: 1.0).CGColor
    var colorBottom = UIColor(red: 24/255.0, green: 90/255.0, blue: 157/255.0, alpha: 1.0).CGColor
    
    let gradient: CAGradientLayer
    
    init() {
        gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorMiddle, colorBottom]
        gradient.locations = [ 0.0, 0.6]
    }
    
    func applyColors() {
        gradient.colors = [colorTop, colorMiddle, colorBottom]
    }
}
