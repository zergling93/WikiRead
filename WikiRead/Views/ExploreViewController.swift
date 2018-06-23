//
//  ViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, WikiPageDODelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var recentPages:Array<WikiPage> = Array<WikiPage>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        self.searchBar.delegate = self;
        
        WikiPageDO.getInstance().addDelegate(delegate: self)
        let pages = WikiPageDO.getInstance().getRecentWikiPagesOffline()
        if let pages = pages, pages.count>0{
            self.recentPages = pages
        }
        
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
    
    func onrecentPagesUpdated() {
        let pages = WikiPageDO.getInstance().getRecentWikiPagesOffline()
        if let pages = pages, pages.count>0{
            self.recentPages = pages
            self.tableView.reloadData()
        }
    }
    
    //MARK: - search methods
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1 = s.instantiateViewController(withIdentifier: "SearchViewController")
        vc1.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(vc1, animated: true, completion: nil)
    }
    
    
    //MARK: - table methods
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell:WikiPageCell = tableView.dequeueReusableCell(withIdentifier: "WikiPageCell", for: indexPath) as! WikiPageCell
            cell.page = self.recentPages[indexPath.row]
            cell.prepareCell()
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let page = self.recentPages[indexPath.row]
        let vc = WebViewController.initWithPage(page: page)
        tableView.deselectRow(at: indexPath, animated: true)
        self.present(vc, animated: true, completion: nil)
    }


}

