//
//  SearchViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var timer:Timer?
    var progress:Float = 0
    
    var searchPages:Array<WikiPage> = Array<WikiPage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressView.setProgress(0, animated: false)
        self.progress = 0
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
        let query = searchText
        if query.count>0{
            if !NetworkInterface.isInternetAvailable(){
                let pages = WikiPageDO.getInstance().getWikiPagesOffline(query: query)
                if let pages = pages{
                    self.searchPages = pages
                    self.tableView.reloadData()
                }
            }else{
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadSearchResults(query:)), object: nil)
                self.perform(#selector(loadSearchResults(query:)), with: query, afterDelay: 0.5)
            }
        }else{
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadSearchResults(query:)), object: nil)
            self.searchPages.removeAll()
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if NetworkInterface.isInternetAvailable(){
            let query = searchBar.text
            if let query = query, query.count>0{
                
            }
        }
    }
    
    @objc func loadSearchResults(query:String)->Void{
        self.startProgress()
        WikiPageDO.getInstance().getWikiPagesOnline(query: query, success: {[weak self] (pages) in
            if let pages = pages, let weakself = self{
                weakself.completeProgress()
                weakself.searchPages = pages
                weakself.tableView.reloadData()
            }
        }) { (errorMessage) in
            print(errorMessage)
        }
    }
    
    func startProgress()->Void{
        self.progressView.setProgress(0, animated: false)
        if let timer = self.timer{
            timer.invalidate()
        }
        self.progress = 0;
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerProgress), userInfo: nil, repeats: true)
    }
    @objc func timerProgress()->Void{
        self.progress = self.progress + 1/10;
        self.progressView.setProgress(self.progress, animated: true)
        if(self.progress>=1){
            self.completeProgress()
        }
    }
    
    func completeProgress()->Void{
        self.progress = 0
        if let timer = self.timer{
            timer.invalidate()
        }
        self.progressView.setProgress(1, animated: true)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton=true
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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
