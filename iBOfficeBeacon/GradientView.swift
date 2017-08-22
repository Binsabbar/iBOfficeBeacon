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
            return UIColor(cgColor: gradientLayer.colorTop)
        }
        set {
            _topColor = newValue
        }
    }
    
    @IBInspectable var middleColor: UIColor? {
        get {
            return UIColor(cgColor: gradientLayer.colorMiddle)
        }
        set {
            _middleColor = newValue
        }
    }
    
    @IBInspectable var bottomColor: UIColor? {
        get {
            return UIColor(cgColor: gradientLayer.colorBottom)
        }
        set {
            _bottomColor = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }
    

    override func setNeedsLayout() {
        super.setNeedsLayout()
        gradientLayer.gradient.removeFromSuperlayer()
        setupGradientColors()
        gradientLayer.gradient.frame = frame
        gradientLayer.gradient.masksToBounds = true
        layer.insertSublayer(gradientLayer.gradient, at: 0)
    }
    
    
    // Keep it for refrence
    fileprivate func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    fileprivate func setupGradientColors() {
        gradientLayer.colorTop = _topColor?.cgColor ?? (topColor?.cgColor)!
        gradientLayer.colorMiddle = _middleColor?.cgColor ?? (middleColor?.cgColor)!
        gradientLayer.colorBottom = _bottomColor?.cgColor ?? (bottomColor?.cgColor)!
        gradientLayer.applyColors()
    }
}
