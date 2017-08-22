//
//  BorderedButton.swift
//  iBOfficeBeacon
//
//  Created by Mohammed Binsabbar on 09/04/2016.
//  Copyright © 2016 Binsabbar. All rights reserved.
//


class UIBorderedButton: UIButton {

    var colorForTapState: UIColor?
    var colorForNormalState: UIColor?
    
    
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
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 4.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 4.0
    }
}
