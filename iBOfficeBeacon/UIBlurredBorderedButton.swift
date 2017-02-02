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
            return UIColor.clearColor()
        }
        set {
            _borderColor = newValue.CGColor
        }
    }
    
    override var highlighted: Bool {
        get { return super.highlighted }
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
            super.highlighted = newValue
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
    
    private func setup() {
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.clearColor().CGColor
        layer.cornerRadius = 4.0
        addBlurEffect(self)
    }
    
    override func setNeedsLayout() {
        self.layer.cornerRadius = _borderRadius ?? borderRadius
        self.layer.borderWidth = _borderWidth ?? borderWidth
        self.layer.borderColor = _borderColor ?? borderColor.CGColor
    }
    
    func addBlurEffect(view: UIView) {
        let blurEffectView: UIVisualEffectView!
        let blurEffect = UIBlurEffect(style: .ExtraLight)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = view.bounds
        
        blurEffectView.layer.borderColor = UIColor.clearColor().CGColor
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.addSubview(vibrancyEffectView)
        blurEffectView.userInteractionEnabled = false
        view.addSubview(blurEffectView)
        view.sendSubviewToBack(blurEffectView)
    }
}
