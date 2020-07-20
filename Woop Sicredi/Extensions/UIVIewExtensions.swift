//
//  UIVIewExtensions.swift
//  Woop Sicredi
//
//  Created by Felipe Baggioto on 19/07/20.
//  Copyright © 2020 Sicredi. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(isBottom: Bool = true) {
        super.init(frame: .zero)
        
        let gradientLayer = self.layer as! CAGradientLayer
        
        if isBottom {
            
            gradientLayer.colors = [
                UIColor.init(white: 1, alpha: 0).cgColor,
                UIColor.white.cgColor
            ]
            
        } else {
            
            gradientLayer.colors = [
                UIColor.white.cgColor,
                UIColor.init(white: 1, alpha: 0).cgColor
            ]
            
        }
        
        backgroundColor = UIColor.clear
    }
}
