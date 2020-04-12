//
//  Player.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/12/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation
import AVFoundation


class Player {
   
//    var btnSound: AVAudioPlayer!
//    var endSound: AVAudioPlayer!
//    var zazen: Double = 60
//    let defaults = UserDefaults.standard
//    let mode = "mode"
//    let bell = "bell"
//    weak var repeatingBellTimer: Timer?
//
//    //var timerRunning: Bool { return self.countdownTimer != nil }
//
//
//    var mute = false
//    var durationTimer:Timer!
//    var bellEndAt: Date!
//
//
//
//
//        //durationTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.checkBellTime), userInfo: nil, repeats: true)
//
//
//  ////SOUND.................................
//        let startNumber = (defaults.integer(forKey: "startNumber"))
//        let endNumber = (defaults.integer(forKey: "endNumber"))
//        let countdownNumber = (defaults.integer(forKey: "endNumber"))
//        let bellSound = (defaults.string(forKey: "bellSound"))!
//        let ext = (defaults.string(forKey: "ext"))!
//
//        print("bellType \(bellSound)")
//        print("file \(bellSound)")
//        print("ext \(ext)")
//
//        var path = Bundle.main.path(forResource: bellSound, ofType: ext)
//        let soundURL = URL(fileURLWithPath: path!)
//
//        do {
//           try AVAudioSession.sharedInstance().setCategory(.playback)
//        } catch(let error) {
//            print(error.localizedDescription)
//        }
//
//        do {
//            try btnSound = AVAudioPlayer(contentsOf: soundURL)
//            btnSound.prepareToPlay()
//        } catch let err as NSError {
//            print(err.debugDescription)
//        }
//
//
//    func timeFormatted(_ totalSeconds: TimeInterval) -> String {
//        let seconds: Int = Int(totalSeconds) % 60
//        if seconds == 0 { return "" }
//        return String(format: "%01d", seconds)
//    }
//
//
//    func playSound(timesPlayed: Int = 0) {
//
//        let bellCount: Int = (defaults.integer(forKey: "startNumber"))
//
//        self.btnSound.currentTime = 0
//        if (bellCount - timesPlayed) > 1 {
//            self.btnSound.play()
//            repeatingBellTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
//                self.playSound(timesPlayed: timesPlayed + 1)
//            }
//        } else {
//            self.btnSound.play()
//        }
//    }
//
//     func playEndSound(timesPlayed: Int = 0) {
//
//           let bellCount: Int = (defaults.integer(forKey: "endNumber"))
//
//        self.btnSound.currentTime = 0
//           if (bellCount - timesPlayed) > 1 {
//               self.btnSound.play()
//               repeatingBellTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
//                   self.playSound(timesPlayed: timesPlayed + 1)
//               }
//           } else {
//               self.btnSound.play()
//           }
//       }
//

}

