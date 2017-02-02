//
//  UIBlurredLabel.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 09/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//

class UIBlurredLabel: UIView {

    var label:UILabel!
    var blurEffectView: UIVisualEffectView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
        setupUILabel()
        addBlurEffect()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        setUILabelConstraints()
    }
    
    private func setupUILabel() {
        label = UILabel()
        label.frame = frame
        label.bounds = bounds
        label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        label.font = UIFont.boldSystemFontOfSize(16)
        label.clipsToBounds = true
        label.textAlignment = .Center
        label.numberOfLines = 0
    }
    
    private func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = bounds

        blurEffectView.layer.borderColor = UIColor.clearColor().CGColor
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        //Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = bounds
        
        vibrancyEffectView.addSubview(label)
        blurEffectView.addSubview(vibrancyEffectView)
        addSubview(blurEffectView)
    }
    
    
    private func setUILabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .LeadingMargin, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .TrailingMargin, multiplier: 1, constant: 5)
        let topConstraint = NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .TopMargin, multiplier: 1, constant: 5)
        let bottomConstraint = NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .BottomMargin, multiplier: 1, constant: 5)
        
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
}
