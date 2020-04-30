//
//  DoanStation.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/29/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit




class DoanStation: UIViewController {
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var bigBellButton: UIButton!
    @IBOutlet weak var smallBellButton: UIButton!
    @IBOutlet weak var mediumBellButton: UIButton!
    @IBOutlet weak var inkinBellButton: UIButton!
   // @IBOutlet weak var rolldownButton: UIButton!
    //@IBOutlet weak var stopButton: UIButton!
    
     var doan: Doan!
    
    func darkMode() {
           self.view.backgroundColor = UIColor.black
       }
       
       func lightMode() {
           self.view.backgroundColor = UIColor.white
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allBells(on: false)
        doan = Doan.instance

          if defaults.bool(forKey: "mode") == true {
                      darkMode()
                  } else {
                      lightMode()
                  }
    }
    
    func switchBells() {
        if bigBellButton.image(for: .normal) == UIImage(named: "doan-stand-large-kesu") {
            bigBellButton.setImage(UIImage(named: "doan-stand-medium-kesu"), for: .normal)
            mediumBellButton.setImage(UIImage(named: "doan-stand-large-kesu"), for: .normal)
        } else {
            bigBellButton.setImage(UIImage(named: "doan-stand-large-kesu"), for: .normal)
            mediumBellButton.setImage(UIImage(named: "doan-stand-medium-kesu"), for: .normal)
        }
    }
    @IBAction func standButtonPressed(_ sender: Any) {
        if inkinBellButton.isHidden == true {
            allBells(on: true)
        } else {
            allBells(on: false)
        }
        
    }
    
    @IBAction func infoButtonPressed(_ sender: Any) {
    }
    
    func allBells(on: Bool) {
        if on == true {
            mediumBellButton.isHidden = false
            inkinBellButton.isHidden = false
            //rolldownButton.isHidden = false
            //stopButton.isHidden = false
        } else {
            mediumBellButton.isHidden = true
            inkinBellButton.isHidden = true
           // rolldownButton.isHidden = true
           // stopButton.isHidden = true
        }
    }
    
    @IBAction func infoButtonTapped(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DoanStationInfoVC") as! DoanStationInfoVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func inkinButtonTapped(_ sender: Any) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InkinPopUpVC") as! InkinPopUpVC
        self.addChild(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func smallBellTapped(_ sender: Any) {
        doan.testBell(name: "small-bell")
    }
    @IBAction func bigBellTapped(_ sender: Any) {
        if bigBellButton.image(for: .normal) == UIImage(named: "doan-stand-medium-kesu") {
        doan.testBell(name: "medium-kesu")
        } else {
            doan.testBell(name: "large-kesu")
        }
    }
    @IBAction func rolldownTapped(_ sender: Any) {
        doan.testBell(name: "rolldown")
    }
    @IBAction func stopTapped(_ sender: Any) {
        doan.testBell(name: "stop")
    }
    @IBAction func bellSwitch(_ sender: Any) {
        switchBells()
    }
    

}
