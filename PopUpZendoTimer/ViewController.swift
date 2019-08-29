//
//  ViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 8/26/19.
//  Copyright © 2019 Joseph Hall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var timerLabel: UILabel!
    
    var countdownTimer: Timer!
    var totalTime = 4
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        timerLabel.text = "\(timeFormatted(totalTime))"
        timerLabel.isHidden = false
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
            timerLabel.isHidden = true
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
    
    
    @IBAction func startTimerPressed(_ sender: UIButton) {
        startTimer()
    }



}

