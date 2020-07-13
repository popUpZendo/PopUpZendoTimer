//
//  InkinPopUpVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/29/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit


class InkinPopUpVC: UIViewController {//@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var inkinBell: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    
    var doan: Doan!
    var seconds = 75 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var broadcast = false
    var selectedGroup = ""
    var playerIDs: [String]?
    var countdownDisplay = 75
    var kinhin: Double = 60
    let kinhinSlide = "kinhinSlide"
    
           //let cornerRadius : CGFloat = 25.0
           
           override func viewDidLoad() {
               super.viewDidLoad()
                
                doan = Doan.instance
            
            timer.invalidate()
            
            //seconds = 65    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
            
            timerLabel.text = "\(countdownDisplay)"
            
            if let kinhinSlide = defaults.value(forKey: kinhinSlide) {
                slider.value = kinhinSlide as! Float
                kinhinSliderValueChanged(slider)
            }
            
               self.showAnimate()
               
               // 1
               view.backgroundColor = .clear
               // 2
               let blurEffect = UIBlurEffect(style: .dark)
               // 3
               let blurView = UIVisualEffectView(effect: blurEffect)
               // 4
               blurView.translatesAutoresizingMaskIntoConstraints = false
               view.insertSubview(blurView, at: 0)
               
               NSLayoutConstraint.activate([
               blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
               blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
               ])
           }
           
           
           func runTimer() {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
           }

    
    @objc func updateTimer() {
        let time = Int(timerLabel.text!)
        seconds = (time!) * 60
        print("Seconds: \(seconds)")
                seconds -= 1     //This will decrement(count down)the seconds.
        if seconds > 60 {
            countdownDisplay = seconds/60
            print(countdownDisplay)
        } else if seconds < 60 {
            countdownDisplay = seconds
        }
                timerLabel.text = "\(countdownDisplay)" //This will update the label.
            }
           
           func showAnimate()
           {
               self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
               self.view.alpha = 0.0;
               UIView.animate(withDuration: 0.25, animations: {
                   self.view.alpha = 1.0
                   self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
               });
           }
           
           func removeAnimate()
           {
               UIView.animate(withDuration: 0.25, animations: {
                   self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                   self.view.alpha = 0.0;
                   }, completion:{(finished : Bool)  in
                       if (finished)
                       {
                           self.view.removeFromSuperview()
                       }
               });
           }
    
    func ringInkinBell() {
        if selectedGroup != "", let list = self.playerIDs {
            OneSignalService.instance.broadcastBell(Group: "Practical Zen", audience: list, Bell: "inkin-bell.aiff")
        }
    }
           
        @IBAction func inkinBellPressed(_ sender: Any) {
            if isTimerRunning == false {
                self.isTimerRunning = true
                print(isTimerRunning)
                runTimer()
                slider.isHidden = true
                doan.testBell(name: "inkin-bell")
                ringInkinBell()
                print("SelectedInkin Group \(selectedGroup)")
                print("Inkin Broadcast: \(broadcast)")
                print("Inkin playerIds: \(String(describing: playerIDs))")
                 } else {
                    timer.invalidate()
                
                    self.isTimerRunning = false
                    print(isTimerRunning)
                    slider.isHidden = false
                    doan.testBell(name: "inkin-bell")
                ringInkinBell()
                
                }
        }
    
    @IBAction func kinhinSliderValueChanged(_ sender: UISlider) {
        kinhin = Double(Int(sender.value))
            let currentValue = Int(sender.value)
            timerLabel.text = "\(currentValue)"
        
        defaults.set(sender.value, forKey: kinhinSlide)
    }
    
        
           @IBAction func closeButtonPressed(_ sender: Any) {
               self.removeAnimate()
               //self.view.removeFromSuperview()
           }

    @IBAction func close(_ sender: Any) {
        self.removeAnimate()
                      //self.view.removeFromSuperview()
    }
    
}
