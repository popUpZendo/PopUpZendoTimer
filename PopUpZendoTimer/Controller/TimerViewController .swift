//
//  TimerViewController.swift
//  Pop Up Zendo Timer
//
//  Created by Joseph Hall on 9/1/19.
//  Copyright © 2019 Om Design. All rights reserved.
//

import UIKit
import AVFoundation
import KDCircularProgress


class TimerViewController: UIViewController {
    
    var progress: KDCircularProgress!
    var zenTimer: ZenTimer!

    var zazen: Double = 60
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    let durationSlide = "durationSlide"
    var doan: Doan!
    
    var timerRunning: Bool { return self.countdownTimer != nil }

    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UISlider!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var gearButton: UIButton!
    @IBOutlet weak var timerHostView: UIView!
    @IBOutlet weak var returnButton: UIButton!
    
   
    var mute = false
    weak var countdownTimer: Timer!
    var countEndAt: Date!
    //var durationTimer:Timer!
    var bellEndAt: Date!
    
    
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        doan = Doan.instance
        
        if self.progress != nil { return }
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        
        if let durationSlide = defaults.value(forKey: durationSlide) {
            slider.value = durationSlide as! Float
            durationSliderValueChanged(slider)
        }
        
        returnButton.isHidden = true
        countDownLabel.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        progress = KDCircularProgress(frame: self.timerHostView.bounds)
        progress.startAngle = -90
        progress.progressThickness = 0.3
        progress.trackThickness = 0.3
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .constant
        progress.glowAmount = 0.3
        progress.trackColor = UIColor.darkGray
        progress.set(colors: UIColor.black)
        self.timerHostView.addSubview(progress)
        progress.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        

        self.view.bringSubviewToFront(self.timerButton)
    }
    
    
    
    func meditate() {
        label.isHidden = true
        slider.isHidden = true
        sliderValue.isHidden = true
        gearButton.isHidden = true
        returnButton.isHidden = false
    }
    
    func prepareForMeditation() {
        label.isHidden = false
        slider.isHidden = false
        sliderValue.isHidden = false
        gearButton.isHidden = false
        returnButton.isHidden = true
    }
    
    func startCountdown() {
        let countdownNumber: Int = (defaults.integer(forKey: "countdownNumber"))
        self.countEndAt = Date(timeIntervalSinceNow: Double(countdownNumber + 1))
        countDownLabel.text = "\(timeFormatted(abs(self.countEndAt!.timeIntervalSinceNow)))"
        countDownLabel.isHidden = false
        countdownTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if let interval = self.countEndAt?.timeIntervalSinceNow, interval > 0 {
            countDownLabel.text = "\(timeFormatted(abs(interval)))"
            countDownLabel.isHidden = false
        } else {
            endCountdown()
            startAnimatedTimer()
            doan.bell.currentTime = 0
        }
    }
    
    func endCountdown() {
        countdownTimer?.invalidate()
        countDownLabel.isHidden = true
        self.stopAnimatedTimer()
        doan.bell.stop()
        label.isHidden = false
        slider.isHidden = false
        sliderValue.isHidden = false
        gearButton.isHidden = false
        returnButton.isHidden = true
    }
    
    func timeFormatted(_ totalSeconds: TimeInterval) -> String {
        let seconds: Int = Int(totalSeconds) % 60
        if seconds == 0 { return "" }
        return String(format: "%01d", seconds)
    }
    
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
            zazen = Double(Int(sender.value))
            let currentValue = Int(sender.value)
            label.text = "\(currentValue)"
        
        defaults.set(sender.value, forKey: durationSlide)
    }
    
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        if self.timerRunning || self.progress.isAnimating() {
            self.stopAnimatedTimer()
            self.endCountdown()
            returnButton.isHidden = true
            return
        }else{
            stopAnimatedTimer()
            startCountdown()
            meditate()
        }
        
    }
    
    @IBAction func animateButtonTapped(_ sender: AnyObject){
        if self.timerRunning || self.progress.isAnimating() {
            self.stopAnimatedTimer()
            self.endCountdown()
            return
        }else{
            stopAnimatedTimer()
            startCountdown()
            meditate()
        }
    }
    
    func startAnimatedTimer() {
         if self.defaults.bool(forKey: "bell") == true {
            let startZazen = (defaults.integer(forKey: "startNumber"))
            doan.strikeBell(startZazen)
            meditate()
        }
        self.progress.animate(fromAngle: 0, toAngle: 360, duration: self.zazen*60) { completed in
            if completed {
                let endZazen = (self.defaults.integer(forKey: "endNumber"))
                if self.defaults.bool(forKey: "bell") == true {
                    self.doan.strikeBell(endZazen)
                    self.returnButton.isHidden = false
                }
            } else {
                
            }
        }
    }
    
    func stopAnimatedTimer() {
        self.progress.stopAnimation()
        self.progress.progress = 0
        doan.bell.stop()
        //self.repeatingBellTimer?.invalidate()

    }

}
