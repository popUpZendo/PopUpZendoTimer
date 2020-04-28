//
//  Stopwatch.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/25/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation




class Stopwatch {
    var timerLabel = ""
    var countdownTimer: Timer!
    var totalTime = 60
    
func startTimer() {
    countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
}

    @objc func updateTime() {
    timerLabel = "\(timeFormatted(totalTime))"

    if totalTime != 0 {
        totalTime -= 1
    } else {
        endTimer()
    }
}

func endTimer() {
    countdownTimer.invalidate()
}

func timeFormatted(_ totalSeconds: Int) -> String {
    let seconds: Int = totalSeconds % 60
    let minutes: Int = (totalSeconds / 60) % 60
    //     let hours: Int = totalSeconds / 3600
    return String(format: "%02d:%02d", minutes, seconds)
}


func startTimerPressed() {
    startTimer()
}

}
