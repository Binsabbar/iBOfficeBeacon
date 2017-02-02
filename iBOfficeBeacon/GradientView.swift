//
//  GradientView.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import UIKit

@IBDesignable class GradientView: UIView {

    var view: UIView!
    var nibName: String = "GradientView"
    
    let gradientLayer = GradientLayer()
    
    var _topColor: UIColor?
    var _bottomColor: UIColor?
    var _middleColor: UIColor?
    
    @IBInspectable var topColor: UIColor? {
        get {
            return UIColor(CGColor: gradientLayer.colorTop)
        }
        set {
            _topColor = newValue
        }
    }
    
    @IBInspectable var middleColor: UIColor? {
        get {
            return UIColor(CGColor: gradientLayer.colorMiddle)
        }
        set {
            _middleColor = newValue
        }
    }
    
    @IBInspectable var bottomColor: UIColor? {
        get {
            return UIColor(CGColor: gradientLayer.colorBottom)
        }
        set {
            _bottomColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    

    override func setNeedsLayout() {
        super.setNeedsLayout()
        gradientLayer.gradient.removeFromSuperlayer()
        setupGradientColors()
        gradientLayer.gradient.frame = frame
        gradientLayer.gradient.masksToBounds = true
        layer.insertSublayer(gradientLayer.gradient, atIndex: 0)
    }
    
    
    // Keep it for refrence
    private func loadFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    private func setupGradientColors() {
        gradientLayer.colorTop = _topColor?.CGColor ?? (topColor?.CGColor)!
        gradientLayer.colorMiddle = _middleColor?.CGColor ?? (middleColor?.CGColor)!
        gradientLayer.colorBottom = _bottomColor?.CGColor ?? (bottomColor?.CGColor)!
        gradientLayer.applyColors()
    }
}
