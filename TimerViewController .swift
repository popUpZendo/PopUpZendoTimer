//
//  TimerViewController.swift
//  Pop Up Circle Test
//
//  Created by Joseph Hall on 6/21/17.
//  Copyright © 2017 Om Design. All rights reserved.
//

import UIKit
import AVFoundation
import KDCircularProgress


class TimerViewController: UIViewController {
    
    var progress: KDCircularProgress!
    var btnSound: AVAudioPlayer!
    var zazen: Double = 60
    let defaults = UserDefaults.standard
    let mode = "mode"
    let bell = "bell"
    let durationSlide = "durationSlide"
    //var timer = 60
    
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
    
   
    var mute = false
    var countdownTimer: Timer!
    var totalTime = 4
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let setMode = defaults.bool(forKey: "mode")
        print(mode)

        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        
        
        
        if let durationSlide = defaults.value(forKey: durationSlide) {
            slider.value = durationSlide as! Float
            durationSliderValueChanged(slider)
        }
        
        
        countDownLabel.isHidden = true
                UIApplication.shared.isIdleTimerDisabled = true
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.view.backgroundColor = UIColor.black
        //view.backgroundColor = UIColor(white: 1.00, alpha: 1.0)
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        progress.startAngle = -90
        progress.progressThickness = 0.3
        progress.trackThickness = 0.31
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = true
        progress.glowMode = .constant
        progress.glowAmount = 0.3
        progress.trackColor = UIColor.darkGray
        progress.set(colors: UIColor.black)
        progress.center = CGPoint(x: view.center.x, y: view.center.y - 80)
        view.addSubview(progress)
        
        
        let path = Bundle.main.path(forResource: "zazenBell3", ofType: "mp3")
        let soundURL = URL(fileURLWithPath: path!)
        
        do {
            try btnSound = AVAudioPlayer(contentsOf: soundURL)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        self.view.bringSubviewToFront(self.timerButton)
        
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        countDownLabel.text = "\(timeFormatted(totalTime))"
        countDownLabel.isHidden = false
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            countDownLabel.isHidden = true
            totalTime = 4
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        return String(format: "%01d", seconds)
    }
    
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        label.text = String(Int(sender.value))
        zazen = Double(Int(sender.value))
    }
 
    
    
    @IBAction func durationSliderValueChanged(_ sender: UISlider) {
            zazen = Double(Int(sender.value))
            let currentValue = Int(sender.value)
            label.text = "\(currentValue)"
        
        defaults.set(sender.value, forKey: durationSlide)
            print ("currentValue \(currentValue)")
    }
    
    
    
    @IBAction func animateButtonTapped(_ sender: AnyObject){
        if self.progress.isAnimating () || btnSound.isPlaying || countDownLabel.isHidden == false {
            self.progress.stopAnimation()
            self.btnSound.stop()
            label.isHidden = false
            slider.isHidden = false
            sliderValue.isHidden = false
            countDownLabel.isHidden = true
            
        } else {
        
        countDownLabel.isHidden = false
        //var clock = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: "countdown", userInfo: nil, repeats: true)
            label.isHidden = true
            slider.isHidden = true
            sliderValue.isHidden = true
            startTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
        
            self.countDownLabel.isHidden = true
            
        func playSound() {
            if self.btnSound.isPlaying {
                self.btnSound.stop()
            } else {
            self.btnSound.play()
            }
        }
        
            if self.defaults.bool(forKey: "bell") == false {
               playSound()
            }
       
        
        self.progress.animate(fromAngle: 0, toAngle: 360, duration: self.zazen*60) { completed in
            if completed {
                if self.defaults.bool(forKey: "bell") == false {
                    playSound()
                }
            } else {
                print("animation stopped, was interrupted")
            }
        }
        
        
    })
    }
}
    
    
}
