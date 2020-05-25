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
    
    private weak var timer: Timer!
    var completion: (() -> Void)?
    private var timerDuration: TimeInterval = 0
    private var startedAt: Date?
    
    var isAnimating: Bool { return self.timer != nil }
    
    var elapsedTime: TimeInterval {
        guard let startedAt = self.startedAt else { return 0 }
        return abs(startedAt.timeIntervalSinceNow)
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    func start(duration: TimeInterval, completion: (() -> Void)?) {
        if self.isAnimating {
            print("Tried to start an existing timer!")
            return
        }
        self.completion = completion
        self.timerDuration = duration
        self.startedAt = Date()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsed = self.elapsedTime
            
            if elapsed > self.timerDuration || self.timerDuration == 0 {
                self.timer?.invalidate()
                self.completion?()
                self.completion = nil
            } else {
                self.progress = (elapsed / self.timerDuration) / 2
                print(elapsed)
            }
        }
    }
    
    func stop() {
        self.timer?.invalidate()
        self.completion = nil
        self.progress = 0
    }
    
    private var progress: Double = 0 {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.shapeLayer?.removeFromSuperlayer()
        self.progressLayer?.removeFromSuperlayer()
        
        simpleShape()
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
        shapeLayer.lineWidth = 22
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        
        //Stroke
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = CAShapeLayerLineCap.round
        progressLayer.lineWidth = 22
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.black.cgColor
        progressLayer.strokeEnd = 0.0
        
        
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    
    private func createCirclePath()
    {
        
        let x = self.frame.width / 2
        let y = self.frame.height / 2
        let center = CGPoint(x: x, y: y)
        bgPath.addArc(withCenter: center, radius: x, startAngle: CGFloat(CGFloat(-0.5 * Double.pi)), endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        bgPath.close()
    }
}
