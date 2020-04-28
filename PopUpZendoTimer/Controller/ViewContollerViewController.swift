//
//  ViewContollerViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/13/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit

class ViewContollerViewController: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    
    @IBOutlet weak var progressBar: ZenTimer!
    
    
    
    
    
    
    //OLD TIMER
    var timer: Timer!
    var progressCounter:Float = 0
    let duration:Float = 120.0
    var progressIncrement:Float = 0
    var timerRunning: Bool { return self.timer != nil }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressIncrement = 1.0/duration
        
    }
    
    
    @IBAction func fireTimer(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
        if(progressCounter > 1.0){timer.invalidate()}
        progressBar.progress = progressCounter
        progressCounter = progressCounter + progressIncrement
    }
    
    @objc func showProgress()
    {
        
    }

}
