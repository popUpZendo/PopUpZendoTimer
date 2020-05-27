//
//  TableViewController.swift


import FoldingCell
import UIKit
import Firebase

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    var sanghaArray = [Group]()
    var myGroupsArray = [Group]()
    var searchArray = [Group]()
    var filteredSanghaArray = [Group]()
    var groupFriendsArray = [String]()
    var oneSignalArray = [String]()

    @IBOutlet weak var showMyButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidAppear(_ animated: Bool) {
                  super.viewDidAppear(animated)
        
        searchBar.delegate = self
                  //DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
                  DataService.instance.getAllGroups { (returnedSanghaArray) in
                      self.sanghaArray = returnedSanghaArray
                    self.filteredSanghaArray = self.sanghaArray
                    self.myGroupsArray = self.sanghaArray.filter{ $0.members.contains(uid) }
                    self.myGroupsArray.forEach { print($0) }
                      self.tableView.reloadData()
                      print("+++++++++++++++returnedSangaArray \(self.sanghaArray)+++++++++++++++++++")
                    print(self.sanghaArray.count)
                    print(self.myGroupsArray.count)
                      }
                  }
    
    enum Const {
          static let closeCellHeight: CGFloat = 179
          static let openCellHeight: CGFloat = 488
          static let rowsCount = 10
      }
    
    
    var cellHeights: [CGFloat] = []

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        filteredSanghaArray = sanghaArray
        print("===============================\(type(of: sanghaArray))=========================")
        
    }
    
    func applyFilter(_ filter: (String) -> Bool) {
        
        
        //filteredSanghaArray = sanghaArray.filter { $0.contains("lo") }
    }

    

    // MARK: Helpers
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "bambooRIver"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    // MARK: Actions
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            } 
            self?.tableView.reloadData()
        })
    }
    
    @IBAction func myGroupsButton(_ sender: Any) {
        if showMyButton.titleLabel!.text == "Show My Groups" {
        self.filteredSanghaArray = self.myGroupsArray
            self.showMyButton.setTitle("Show All Groups", for: .normal)
        self.tableView.reloadData()
            
    } else {
        self.filteredSanghaArray = self.sanghaArray
            self.showMyButton.setTitle("Show My Groups", for: .normal)
            self.tableView.reloadData()
    }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchArray = self.sanghaArray

        if searchText.isEmpty == false {
            
            //self.sanghaArray.filter{ $0.members.contains(uid) }

            searchArray = self.sanghaArray.filter{ $0.self.groupName.contains(searchText)
                || $0.self.city.contains(searchText)
                || $0.self.roshi.contains(searchText)
            }
            self.filteredSanghaArray = searchArray
        }

        tableView.reloadData()
        print("Search Bar _________________________________")
        print(filteredSanghaArray)
    }
    
    
}

// MARK: - TableView

extension TableViewController {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return filteredSanghaArray.count
    }

    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }

        cell.backgroundColor = .clear

        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }

        //cell.number = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath) as! DemoCell
        let group = filteredSanghaArray[indexPath.row]
        
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        cell.configureCell(title: group.groupName, temple: group.temple, city: group.city, ino: group.ino, roshi: group.roshi, website: group.website, details: group.details, weekday: group.weekday, logo: group.logo, banner: group.pic, members: group.members, zoom: group.zoom )
        
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell

        if cell.isAnimating() {
            return
        }

        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            
            // fix https://github.com/Ramotion/folding-cell/issues/169
            if cell.frame.maxY > tableView.frame.maxY {
                tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }, completion: nil)
    }
}
