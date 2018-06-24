//
//  WebViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
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
    var flag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavBar()
        loadWebView()
    }
    func loadNavBar()->Void{
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        let image = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 120, height: 24))
        image.image = UIImage.init(named: "text")
        view.addSubview(image)
        self.navigationItem.titleView = view
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back))
    }
    
    
    
    
    
    
    
    func loadWebView()->Void{
        self.spinner.startAnimating()
        self.webView.delegate = self
        if NetworkInterface.isInternetAvailable(){
            self.loadWebViewOnline()
        }else{
            self.loadWebViewOffline()
        }
    }
    
    
    func loadWebViewOffline()->Void{
        if let page = page{
            DispatchQueue.global(qos: .background).async {
                let wpage = WikiPageDO.getInstance().getWikiPageOfflineWith(pageID: page.pageID!)
                if let wpage = wpage{
                    if let data = WikiPageDO.getInstance().getDataFromPageOffline(page: wpage){
                        let str = page.pageURL
                        if let url = URL.init(string: str!){
                            
                            DispatchQueue.main.async {
                                
                                self.topConstraint.constant = 0;
                                self.webView.load(data, mimeType: "text/html", textEncodingName: "", baseURL:url )
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func loadWebViewOnline()->Void{
        if let page = page{
            WikiPageDO.getInstance().getWikiPageURL(page: page, success: { [weak self] (url) in
                WikiPageDO.getInstance().savePageData(page: page)
                if let weakSelf = self {
                    let request = WikiPageDO.getInstance().getDataFromPageOnline(page: page)
                    if let request = request{
                        weakSelf.topConstraint.constant = -70;
                        weakSelf.view.layoutIfNeeded()
                        weakSelf.flag = true
                        weakSelf.webView.loadRequest(request)
                    }
                }
            }) { (errorMessage) in
                print(errorMessage)
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
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.spinner.stopAnimating()
    }
    

    
    @objc func back()->Void{
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
