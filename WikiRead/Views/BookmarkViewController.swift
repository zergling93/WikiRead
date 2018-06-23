//
//  BookmarkViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var bookmarkPages:Array<WikiPage> = Array<WikiPage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        self.searchBar.delegate = self
        
        self.tableView.delegate=self; self.tableView.dataSource=self
        self.tableView.register(UINib.init(nibName: "WikiPageCell", bundle: nil), forCellReuseIdentifier: "WikiPageCell")
        self.tableView.allowsSelection = true
        self.tableView.tableFooterView = UIView.init()
    }
    
    func loadNavBar()->Void{
        self.navigationItem.titleView = UIImageView.init(image: UIImage.init(named: ""))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - search methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=false
        searchBar.resignFirstResponder()
    }
    
    
    //MARK: - table methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Bookmarks"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookmarkPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WikiPageCell = tableView.dequeueReusableCell(withIdentifier: "WikiPageCell", for: indexPath) as! WikiPageCell
        cell.page = self.bookmarkPages[indexPath.row]
        cell.prepareCell()
        return cell
    }

}
