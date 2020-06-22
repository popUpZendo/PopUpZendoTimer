//
//  setDoanVC.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 6/21/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit

class setDoanVC: UIViewController {
    
    var groups = [""]
    var selectedGroup = ""
    var broadcast = false
    var sanghaArray: [Group]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.sanghaArray = FirebaseInterface.instance.groups
    }
    
}

extension setDoanVC:  UITableViewDelegate, UITableViewDataSource {
    
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
        performSegue(withIdentifier: "goToDoanStationVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DoanStation = segue.destination as? DoanStation {
            DoanStation.selectedGroup = self.selectedGroup
            DoanStation.broadcast = true
        }
    }

}
