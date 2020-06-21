//
//  membersCell.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/26/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit

class membersCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doanButton: UIButton!
    
    func configureCell(bodhi: Bodhi) {
        self.nameLabel.text = bodhi.name
        if bodhi.doan {
            self.doanButton.isHidden = false
            self.doanButton.setTitle("doan", for: .normal)
        }else{
            self.doanButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
