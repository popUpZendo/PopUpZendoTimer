//
//  ViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/29/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import AVKit
import FirebaseAuth

class ViewController: UIViewController {

    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var InstructionTextField: UILabel!
    @IBOutlet weak var haikuTextField: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set up video in the background
        setUpVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "goToGroups", sender: self)
        }
    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        haikuTextField.alpha = 0
        InstructionTextField.alpha = 0
        emailTextField.alpha = 0
        sendButton.alpha = 0
        
    }
    
    func setUpVideo() {
        
        // Get the path to the resource in the bundle
        let bundlePath = Bundle.main.path(forResource: "PopUpVid", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create the player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create the layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Adjust the size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // Add it to the view and play it
        videoPlayer?.playImmediately(atRate: 0.3)
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        haikuTextField.alpha = 1
        InstructionTextField.alpha = 1
        emailTextField.alpha = 1
        sendButton.alpha = 1
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
       Auth.auth().sendPasswordReset(withEmail: "email@email") { error in
        self.InstructionTextField.text = "\(error?.localizedDescription ?? "")"
       }
        
        InstructionTextField.text = "Check your email and come back here. BTW, You still have access to the timer and settings."
        emailTextField.alpha = 0
        sendButton.alpha = 0
        
        
        
    }
    
  
    
}


