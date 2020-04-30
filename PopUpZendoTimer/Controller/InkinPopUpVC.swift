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
        
    var doan: Doan!
    var seconds = 60 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
           
           //let cornerRadius : CGFloat = 25.0
           
           override func viewDidLoad() {
               super.viewDidLoad()

    //           containerView.layer.cornerRadius = cornerRadius
    //           containerView.layer.shadowColor = UIColor.darkGray.cgColor
    //           containerView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
    //           containerView.layer.shadowRadius = 25.0
    //           containerView.layer.shadowOpacity = 0.9
               
               //gotItButton.layer.cornerRadius = 10
               //moreHanButton.layer.cornerRadius = 10
                
                doan = Doan.instance
            
            timer.invalidate()
            runTimer()
            seconds = 60    //Here we manually enter the restarting point for the seconds, but it would be wiser to make this a variable or constant.
            timerLabel.text = "\(seconds)"
            
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
                seconds -= 1     //This will decrement(count down)the seconds.
                timerLabel.text = "\(seconds)" //This will update the label.
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
           
        @IBAction func inkinBellPressed(_ sender: Any) {
            doan.testBell(name: "inkin-bell")
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
