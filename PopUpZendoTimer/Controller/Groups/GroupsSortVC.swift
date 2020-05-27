//
//  GroupsSortVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/26/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit


class GroupsSortVC: UIViewController {
    
    var groups = [""]
    var selectedGroup = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    



    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        print("GROUPS_________________ \(groups)")
        
    }
  
}

extension GroupsSortVC:  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortGroupsCell", for: indexPath)
        let group = groups[indexPath.row]
        cell.textLabel?.text = group

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGroup = groups[indexPath.row]
        performSegue(withIdentifier: "goToGroupMembersVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let GroupMembersVC = segue.destination as? GroupMembersVC {
            GroupMembersVC.selectedGroup = self.selectedGroup
        }
    }

}
