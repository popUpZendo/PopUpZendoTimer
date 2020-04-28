//
//  hanInfoVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 4/25/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit

class hanInfoVC: UIViewController {
    //@IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var moreHanButton: UIButton!
    
       
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
           self.showAnimate()
           
           // 1
           //view.backgroundColor = .clear
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
       
    @IBAction func moreHanPressed(_ sender: Any) {
        if let url = URL(string: "https://popupzendo.org/app") {
            UIApplication.shared.open(url)
        }
    }
    
       @IBAction func closeInstructionButton(_ sender: Any) {
           self.removeAnimate()
           //self.view.removeFromSuperview()
       }

}
