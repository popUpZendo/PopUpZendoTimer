//
//  Doan.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/12/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import Foundation
import AVFoundation


class Doan {
    static let instance = Doan()
    
        var bell: AVAudioPlayer!
        var endbell: AVAudioPlayer!
        weak var repeatingBellTimer: Timer?
        var han: AVAudioPlayer!
        var bellTest: AVAudioPlayer!
        var hanCount = 0
        //var tryBell = "small-bell"
        let startZazen = (defaults.integer(forKey: "startNumber"))

        // Initializer
        private init() {
            let bellSound = (defaults.string(forKey: "bellSound"))!
            let ext = (defaults.string(forKey: "ext"))!
            let path = Bundle.main.path(forResource: bellSound, ofType: ext)
            let soundURL = URL(fileURLWithPath: path!)
            

             do {
                          try AVAudioSession.sharedInstance().setCategory(.playback)
                       } catch(let error) {
                           print(error.localizedDescription)
                       }
               
                       do {
                           try bell = AVAudioPlayer(contentsOf: soundURL)
                           bell.prepareToPlay()
                       } catch let err as NSError {
                           print(err.debugDescription)
                       }
            
            
                //let hanSound = "han"
                //let ext = (defaults.string(forKey: "ext"))!
                let hanPath = Bundle.main.path(forResource: "han", ofType: "aiff")
                let hanSoundURL = URL(fileURLWithPath: hanPath!)
                

                 do {
                              try AVAudioSession.sharedInstance().setCategory(.playback)
                           } catch(let error) {
                               print(error.localizedDescription)
                           }
                   
                           do {
                               try han = AVAudioPlayer(contentsOf: hanSoundURL)
                               han.prepareToPlay()
                           } catch let err as NSError {
                               print(err.debugDescription)
                           }
            }
    
    func cancelBells() {
        self.bell.stop()
        self.repeatingBellTimer?.invalidate()
    }
    
    func strikeBell(_ count: Int) {
        if count == 0 { return }
        self.bell.currentTime = 0
        self.bell.play()
        
        print("Playing bell, \(count - 1) left")
        repeatingBellTimer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
            self.strikeBell(count - 1)
        }
    }
    
    
    func testBell(name: String) {
     let tryBell = name
     //let ext = (defaults.string(forKey: "ext"))!
     let tryPath = Bundle.main.path(forResource: tryBell, ofType: "aiff")
     let trySoundURL = URL(fileURLWithPath: tryPath!)
     

      do {
                   try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
        
                do {
                    try bell = AVAudioPlayer(contentsOf: trySoundURL)
                    bell.prepareToPlay()
                } catch let err as NSError {
                    print(err.debugDescription)
                }
                  self.bell.stop()
                  self.bell.currentTime = 0
                      self.bell.play()

              }
        
       
       func strikeHan() {
                 if self.han.isPlaying {
                  self.han.stop()
                  //updateUI(false)
                 } else {
                  continueHan()
                  if hanCount > 0 && hanCount <= (15 * 60) {
                      self.han.currentTime = Double(hanCount)
                      print("Current Time Active \(han.currentTime)")
                  } else {
                      self.han.currentTime = 0
                  }
                      self.han.stop()
                      self.han.play()
                      let remainingTime = ((han.duration - han.currentTime) / 60)
                      //updateUI(true)
                    print("Remaining Time \(remainingTime)")
                }
        
             }
    
    func continueHan() /*-> Int*/ {
          let date = Date()
          let hanTime = UserDefaults.standard.object(forKey: "hanTime") as! Date
           let hanCount = Calendar.current.dateComponents([.second], from: date, to: hanTime).second!
//           if hanCount > 0 && hanCount < (15 * 60){
//               //playLabel.isHidden = false
//           } else {
//               //playLabel.isHidden = true
//           }
           self.hanCount = hanCount
           //return self.hanCount
       }
            
    
    
}



