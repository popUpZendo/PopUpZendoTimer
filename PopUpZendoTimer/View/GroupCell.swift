//
//  GroupCell.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/9/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//


import UIKit

class GroupCell: UITableViewCell {

    
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var groupDescLbl: UILabel!
    @IBOutlet weak var memberCountLbl: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLbl.text = title
        self.groupDescLbl.text = description
        self.memberCountLbl.text = "\(memberCount) members."
    }
    
}
