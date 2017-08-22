//
//  UIBlurredBorderedButton.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 28/05/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

import UIKit

@IBDesignable class UIBlurredBorderedButton: UIButton {
    
    var colorForTapState: UIColor?
    var colorForNormalState: UIColor?
    
    var _borderWidth:CGFloat?
    var _borderRadius:CGFloat?
    var _borderColor:CGColor?
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return 1.0
        }
        set {
            _borderWidth = newValue
        }
    }
    
    @IBInspectable var borderRadius: CGFloat {
        get {
            return 4.0
        }
        set {
            _borderRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor.clear
        }
        set {
            _borderColor = newValue.cgColor
        }
    }
    
    override var isHighlighted: Bool {
        get { return super.isHighlighted }
        set {
            if newValue {
                if let color = colorForTapState {
                    backgroundColor = color
                }
            }
            else {
                if let color = colorForNormalState {
                    backgroundColor = color
                }
            }
            super.isHighlighted = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = 4.0
        addBlurEffect(self)
    }
    
    override func setNeedsLayout() {
        self.layer.cornerRadius = _borderRadius ?? borderRadius
        self.layer.borderWidth = _borderWidth ?? borderWidth
        self.layer.borderColor = _borderColor ?? borderColor.cgColor
    }
    
    func addBlurEffect(_ view: UIView) {
        let blurEffectView: UIVisualEffectView!
        let blurEffect = UIBlurEffect(style: .extraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = view.bounds
        
        blurEffectView.layer.borderColor = UIColor.clear.cgColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.addSubview(vibrancyEffectView)
        blurEffectView.isUserInteractionEnabled = false
        view.addSubview(blurEffectView)
        view.sendSubview(toBack: blurEffectView)
    }
}
