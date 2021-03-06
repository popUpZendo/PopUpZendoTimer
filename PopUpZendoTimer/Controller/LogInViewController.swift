//
//  LogInViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/29/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            
            setUpElements()
        }
        
        func setUpElements() {
            
            // Hide the error label
            errorLabel.alpha = 0
            
            // Style the elements
            Utilities.styleTextField(emailTextField)
            Utilities.styleTextField(passwordTextField)
            Utilities.styleFilledButton(loginButton)
    }
    
    func validateFields() -> String? {
        
        // Check that all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        
        return nil
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {// TODO: Validate Text Fields
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                // after successful sign in, upload the player ID
                if let currentUser = result?.user {
                    OneSignalService.instance.uploadPlayerId(forUID: currentUser.uid, withKey: nil, sendComplete: { (isComplete) in
                        if isComplete {
                            print("Completed playerID Upload")
                        } else {
                            print("There was an error!")
                        }
                    })
                }
                
                // set the root view controller to Home VC
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                    let window = appDelegate.window,
                    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.Storyboard.homeViewController) as? HomeViewController {
                    
                    window.rootViewController = homeVC
                }
            }
        }
    }
    
}
