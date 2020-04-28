//
//  ZenTimer.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/13/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit

class ZenTimer: UIView {
    var bgPath: UIBezierPath!
        var shapeLayer: CAShapeLayer!
        var progressLayer: CAShapeLayer!
        
        var progress: Float = 0 {
            willSet(newValue)
            {
                progressLayer.strokeEnd = CGFloat(newValue)
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            bgPath = UIBezierPath()
            self.simpleShape()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            bgPath = UIBezierPath()
            self.simpleShape()
        }
        
        func simpleShape()
        {
            //Track
            createCirclePath()
            shapeLayer = CAShapeLayer()
            shapeLayer.path = bgPath.cgPath
            shapeLayer.lineWidth = 20
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.darkGray.cgColor
            
            //Stroke
            progressLayer = CAShapeLayer()
            progressLayer.path = bgPath.cgPath
            progressLayer.lineCap = CAShapeLayerLineCap.round
            progressLayer.lineWidth = 20
            progressLayer.fillColor = nil
            progressLayer.strokeColor = UIColor.black.cgColor
            progressLayer.strokeEnd = 0.0
            

            
            self.layer.addSublayer(shapeLayer)
            self.layer.addSublayer(progressLayer)
        }
        
        private func createCirclePath()
        {
            
            let x = self.frame.width
            let y = self.frame.height
            let center = CGPoint(x: x, y: y)
            print(x,y,center)
            bgPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(CGFloat(-0.5 * Double.pi)), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
            bgPath.close()
        }
    }
