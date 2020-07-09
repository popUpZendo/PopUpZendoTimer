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
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var bigBellButton: UIButton!
    @IBOutlet weak var smallBellButton: UIButton!
    @IBOutlet weak var mediumBellButton: UIButton!
    @IBOutlet weak var inkinBellButton: UIButton!
    @IBOutlet weak var bellNoteLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    // @IBOutlet weak var rolldownButton: UIButton!
    //@IBOutlet weak var stopButton: UIButton!
    
    var doan: Doan!
    var broadcast = false
    var selectedGroup = ""
    var groups = [""]
    var doanForGroup = ""
    var playerIDs: [String]?
    
    func darkMode() {
        self.view.backgroundColor = UIColor.black
    }
    
    func lightMode() {
        self.view.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bellNoteLabel.isHidden = true
        allBells(on: false)
        doan = Doan.instance
        if selectedGroup == "" {
            groupNameLabel.isHidden = true
        } else {
            groupNameLabel.text = selectedGroup
            groupNameLabel.isHidden = false
        }
        broadcastButton.setImage(UIImage(named: "broadcast-off"), for: .normal)
        broadcastButton.setImage(UIImage(named: "broadcast-on"), for: .selected)
        
        if defaults.bool(forKey: "mode") == true {
            darkMode()
        } else {
            lightMode()
        }
        
        if broadcast == true {
            broadcastButton.isSelected = true
        } else {
            broadcastButton.isSelected = false
        }
 
        OneSignalService.instance.prepareToBroadcast(selectedGroup: selectedGroup) { list in
            
            self.playerIDs = list
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
    
    func bellNote () {
        bellNoteLabel.text = selectedGroup
        bellNoteLabel.isHidden = false
        UIView.animate(withDuration: 10, animations: { () -> Void in
            self.bellNoteLabel.alpha = 0
        })
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
        popOverVC.broadcast = broadcast
        popOverVC.selectedGroup = selectedGroup
        popOverVC.playerIDs = playerIDs
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParent: self)
    }
    
    @IBAction func smallBellTapped(_ sender: Any) {
        doan.testBell(name: "small-bell")
        ////////
        if selectedGroup != "", let list = self.playerIDs {
            OneSignalService.instance.broadcastBell(Group: selectedGroup, audience: list, Bell: "small-bell.aiff")
        }
        bellNote()
        
    }
    @IBAction func bigBellTapped(_ sender: Any) {
        guard let list = self.playerIDs else { return }
        if bigBellButton.image(for: .normal) == UIImage(named: "doan-stand-medium-kesu") {
            doan.testBell(name: "medium-kesu")
            OneSignalService.instance.broadcastBell(Group: selectedGroup, audience: list, Bell: "medium-kesu-short.aiff")
        } else {
            doan.testBell(name: "large-kesu")
            OneSignalService.instance.broadcastBell(Group: selectedGroup, audience: list, Bell: "large-kesu.aiff")
        }
    }
    @IBAction func rolldownTapped(_ sender: Any) {
        doan.testBell(name: "rolldown")
        guard let list = self.playerIDs else { return }
        OneSignalService.instance.broadcastBell(Group: selectedGroup, audience: list, Bell: "rolldown.aiff")
    }
    @IBAction func stopTapped(_ sender: Any) {
        doan.testBell(name: "stop")
        guard let list = self.playerIDs else { return }
        OneSignalService.instance.broadcastBell(Group: selectedGroup, audience: list, Bell: "stop.aiff")
    }
    @IBAction func bellSwitch(_ sender: Any) {
        switchBells()
    }
    @IBAction func broadcastButton(_ sender: UIButton) {
        if broadcastButton.isSelected == true {
            broadcast = false
            broadcastButton.isSelected = false
            groupNameLabel.isHidden = true
        } else {
            broadcast = true
            broadcastButton.isSelected = true
            performSegue(withIdentifier: "goToSetDoanVC", sender: self)
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let setDoanVC = segue.destination as? setDoanVC {
//            setDoanVC.groups = groups.filter({ $0 != ""})
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
    if segue.identifier == "goToSetDoanVC" {
        if let setDoanVC = segue.destination as? setDoanVC {
            setDoanVC.groups = groups.filter({ $0 != ""})
        }
    }
    }
    
}


