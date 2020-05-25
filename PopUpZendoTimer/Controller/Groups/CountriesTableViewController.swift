//
//  CountriesTableViewController.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 5/13/20.
//  Copyright © 2020 Joseph Hall. All rights reserved.
//

import UIKit
import Firebase



class CountriesTableViewController: UITableViewController {
    
    var sanghaArray = [Group]()
    var groupFriendsArray = [String]()
    var oneSignalArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
      
    }
    override func viewDidAppear(_ animated: Bool) {
               super.viewDidAppear(animated)
               //DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
               DataService.instance.getAllGroups { (returnedSanghaArray) in
                   self.sanghaArray = returnedSanghaArray
                   self.tableView.reloadData()
                   print("returnedSangaArray \(self.sanghaArray)")
                   }
               }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  sanghaArray.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) 

        // Configure the cell...
         //let country = countries[indexPath.row]
        let group = sanghaArray[indexPath.row]
        cell.textLabel?.text = group.groupName
        cell.detailTextLabel?.text = "Test"
        //cell.imageView?.image = UIImage(named: country.isoCode)
        cell.imageView?.image = UIImage(named: "doan-small-bell")
        
        return cell
    }
    


    

}
