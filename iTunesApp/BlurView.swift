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
    var shape = CAShapeLayer()
    public var btnCenter = CGPoint(x: 0, y: 0)
   init(effect: UIVisualEffect?, frame: CGRect) {
        super.init(effect: effect)
    self.frame = frame
    self.btnCenter = CGPoint(x: (frame.width/2) + 35, y:35)
    let path = UIBezierPath()
    path.moveToPoint(CGPoint(x: 0, y:35))
    path.addLineToPoint(CGPoint(x: (frame.width/2), y:35))
    path.addArcWithCenter(self.btnCenter, radius: 35, startAngle: CGFloat(M_PI), endAngle: 0, clockwise: true)
    path.addLineToPoint(CGPoint(x: frame.maxX, y: 35))
    path.addLineToPoint(CGPoint(x: frame.maxX, y: frame.maxY))
    path.addLineToPoint(CGPoint(x: frame.minX, y: frame.maxY))
    path.closePath()
    
    shape.path = path.CGPath
    self.layer.mask = shape

    }
    
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}
