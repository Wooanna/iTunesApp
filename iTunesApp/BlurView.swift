//
//  BlurView.swift
//  iTunesApp
//
//  Created by Yoanna Mareva on 6/29/16.
//  Copyright © 2016 Yoanna Mareva. All rights reserved.
//

import UIKit
import CoreGraphics
import QuartzCore
import AVFoundation

public class BlurView: UIVisualEffectView {
    public var shape = CAShapeLayer()
    
   init(effect: UIVisualEffect?, frame: CGRect) {
        super.init(effect: effect)
    self.frame = frame
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: 0, y:35))
    path.addLineToPoint(CGPoint(x: self.frame.maxX / 2, y:35))
    path.addArcWithCenter(CGPoint(x: self.frame.width / 2 + 35, y:35), radius: 35, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
    path.addLineToPoint(CGPoint(x: self.frame.maxX, y: 35))
    path.addLineToPoint(CGPoint(x: self.frame.maxX, y: self.frame.maxY))
    path.addLineToPoint(CGPoint(x: self.frame.minX, y: self.frame.maxY))
    path.closePath()
    
    shape.path = path.CGPath
    self.layer.mask = shape

    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
