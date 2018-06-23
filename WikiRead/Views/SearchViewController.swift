//
//  SearchViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchPages:Array<WikiPage> = Array<WikiPage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self;
        self.tableView.delegate=self; self.tableView.dataSource=self
        self.tableView.register(UINib.init(nibName: "WikiPageCell", bundle: nil), forCellReuseIdentifier: "WikiPageCell")
        self.tableView.allowsSelection = true
        self.tableView.tableFooterView = UIView.init()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBar.becomeFirstResponder();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - search methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !NetworkInterface.isInternetAvailable(){
            let query = searchText
            if query.count>0{
                let pages = WikiPageDO.getInstance().getWikiPagesOffline(query: query)
                if let pages = pages{
                    self.searchPages = pages
                    self.tableView.reloadData()
                }
            }else{
                self.searchPages.removeAll()
                self.tableView.reloadData()
            }
        }

    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        if NetworkInterface.isInternetAvailable(){
//            let query = searchBar.text
//            if let query = query, query.count>0{
//                WikiPageDO.getInstance().getWikiPagesOnline(query: query, success: { (pages) in
//                    if let pages = pages{
//                        self.searchPages = pages
//                        self.tableView.reloadData()
//                    }
//                    
//                }) { (errorMessage) in
//                    
//                }
//            }
//            
//        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if NetworkInterface.isInternetAvailable(){
            let query = searchBar.text
            if let query = query, query.count>0{
                WikiPageDO.getInstance().getWikiPagesOnline(query: query, success: { (pages) in
                    if let pages = pages{
                        self.searchPages = pages
                        self.tableView.reloadData()
                    }
                    
                }) { (errorMessage) in
                    
                }
            }

        }

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - table methods
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WikiPageCell = tableView.dequeueReusableCell(withIdentifier: "WikiPageCell", for: indexPath) as! WikiPageCell
        cell.page = self.searchPages[indexPath.row]
        cell.prepareCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page = self.searchPages[indexPath.row]
        let vc = WebViewController.initWithPage(page: page)
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(vc, animated: true, completion: nil)
    }

}
