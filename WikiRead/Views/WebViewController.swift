//
//  WebViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    static func initWithPage(page:WikiPage)->UIViewController{
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1:WebViewController = s.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        let nav1 = UINavigationController.init(rootViewController: vc1)
        vc1.page = page
        return nav1
    }
    
    var page:WikiPage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        loadWebView()
    }
    func loadNavBar()->Void{
        self.navigationItem.titleView = UIImageView.init(image: UIImage.init(named: ""))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
    }
    
    func loadWebView()->Void{
        self.spinner.startAnimating()
        self.webView.delegate = self
        if let page = page{
            
            DispatchQueue.global(qos: .background).async{
                let wpage = WikiPageDO.getInstance().getWikiPageOfflineWith(pageID: page.pageID!)
                if let wpage = wpage{
                    let request = WikiPageDO.getInstance().getURLRequestFromPageDataOffline(page: wpage)
                    if let request = request{
                        DispatchQueue.main.async {
                            self.webView.loadRequest(request)
                        }
                    }
                }
            }
            
            if NetworkInterface.isInternetAvailable(){
                WikiPageDO.getInstance().getWikiPageURL(page: page, success: { [weak self] (url) in
                    if let weakSelf = self {
                        weakSelf.savePageOffline()
                        let request = WikiPageDO.getInstance().getURLRequestFromPageOnline(page: page)
                        if let request = request{
                            weakSelf.webView.loadRequest(request)
                        }
                    }
                }) { (errorMessage) in
                    
                }
            }
        }
    }
    
    func savePageOffline()->Void{
        WikiPageDO.getInstance().savePageData(page: self.page!)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.spinner.stopAnimating()
    }
    

    
    @objc func back()->Void{
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
