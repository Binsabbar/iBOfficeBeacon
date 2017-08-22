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
        backgroundColor = UIColor.clear
        setupUILabel()
        addBlurEffect()
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        setUILabelConstraints()
    }
    
    fileprivate func setupUILabel() {
        label = UILabel()
        label.frame = frame
        label.bounds = bounds
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.clipsToBounds = true
        label.textAlignment = .center
        label.numberOfLines = 0
    }
    
    fileprivate func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.clipsToBounds = true
        blurEffectView.frame = bounds

        blurEffectView.layer.borderColor = UIColor.clear.cgColor
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = bounds
        
        vibrancyEffectView.addSubview(label)
        blurEffectView.addSubview(vibrancyEffectView)
        addSubview(blurEffectView)
    }
    
    
    fileprivate func setUILabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 5)
        let trailingConstraint = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailingMargin, multiplier: 1, constant: 5)
        let topConstraint = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .topMargin, multiplier: 1, constant: 5)
        let bottomConstraint = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottomMargin, multiplier: 1, constant: 5)
        
        self.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
    
}
