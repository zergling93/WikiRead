//
//  WikiPageDO.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit


@objc protocol WikiPageDODelegate {
    @objc optional func onrecentPagesUpdated()
}

class WikiPageDO: NSObject {
    
    
    static var instance : WikiPageDO?
    static func getInstance()->WikiPageDO{
        if instance == nil{
            instance = WikiPageDO()
        }
        return instance!
    }
    
    var delegates:Array<WikiPageDODelegate> = Array<WikiPageDODelegate>()
    
    let queryURL:String = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpslimit=10&gpssearch="
    let pageURL:String = "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=info&inprop=url&pageids="

    
    var recentPages:Array<WikiPage> = Array<WikiPage>()
    
    
    
    //MARK: - delegate methods
    func addDelegate(delegate:WikiPageDODelegate)->Void{
        if !self.delegates.contains(where: {$0 === delegate}){
            self.delegates.append(delegate)
        }
    }
    
    func removeDelegate(delegate:WikiPageDODelegate)->Void{
        let index = self.delegates.index(where: {$0 === delegate})
        if let index = index{
            self.delegates.remove(at: index)
        }
    }
    
    
    //MARK: - offline methods
    func getRecentWikiPagesOffline()->Array<WikiPage>?{
        let pageArray:Array<Page>? = Page.mr_findAllSorted(by: "timestamp", ascending: false) as? Array<Page>
        if let pageArray = pageArray, pageArray.count>0{
            var pages:Array<WikiPage> = Array<WikiPage>()
            let count = pageArray.count
            let index = count < 20 ? count : 20
            for i in 0..<index{
                pages.append(WikiPage(page:pageArray[i]))
            }
            return pages
        }
        return nil
    }
    
    
    func getWikiPagesOffline(query : String)->Array<WikiPage>?{
        let predicate = NSPredicate(format:"title contains[cd] %@ || page_desciption contains[cd] %@",query,query)
        let pageArray:Array<Page>? = Page.mr_findAll(with: predicate) as? Array<Page>
        if let pageArray = pageArray, pageArray.count>0{
            var pages:Array<WikiPage> = Array<WikiPage>()
            for page in pageArray{
                pages.append(WikiPage(page: page))
            }
            return pages
        }
        return nil
    }
    
    private func saveWikiPageOffline(wpage: WikiPage, success:@escaping ()->Void, failure:@escaping (String)->Void)->Void{
        
        MagicalRecord.save({ (context) in
            if let wipage = self.getWikiPageOfflineWith(pageID: wpage.pageID!){
                let predicate = NSPredicate(format:"page_id contains[cd] %@",wipage.pageID!)
                Page.mr_deleteAll(matching: predicate, in: context)
            }
            let page = Page.mr_createEntity(in: context)
            if let page = page{
                page.title = wpage.title
                page.image = wpage.image
                page.page_desciption = wpage.pageDescription
                page.page_id = wpage.pageID
                page.timestamp = wpage.timestamp
                page.page_url = wpage.pageURL
            }
        }) { (pass, error) in
            if pass{
                DispatchQueue.main.async {
                    for delegate in self.delegates{
                        if let method = delegate.onrecentPagesUpdated{
                            method()
                        }
                    }
                    success()
                }
            }else if let error = error{
                failure(error.localizedDescription)
            }
        }
    }
    
    func getWikiPageOfflineWith(pageID: String)->WikiPage?{
        let predicate = NSPredicate(format:"page_id contains[cd] %@",pageID)
        let page = Page.mr_findFirst(with: predicate)
        if let page = page{
            return WikiPage(page: page)
        }
        return nil
    }
    
    
    
    //MARK: - online methods
    func getWikiPagesOnline(query : String, success:@escaping (Array<WikiPage>?)->Void, failure:@escaping (String)->Void)->Void{
        let url = "\(queryURL)\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")"
        NetworkInterface .callGetApi(urlString: url, success: { (json) in
            var flag = false
            if let json = json{
                let query:Dictionary<String,Any>? = json["query"] as? Dictionary<String, Any>
                if let query = query{
                    let pages:Array<Dictionary<String,Any>>? = query["pages"] as? Array<Dictionary<String,Any>>
                    if let pages = pages, pages.count>0{
                        flag = true
                        var wpages = Array<WikiPage>()
                        for page in pages{
                            let wpage = WikiPage.init(page: page)
                            wpages.append(wpage)
                        }
                        DispatchQueue.main.async {
                            success(wpages)
                        }
                    }
                }
            }
            if !flag {
                DispatchQueue.main.async {
                    failure("No Data Found")
                }
            }
        }) { (errorMessage) in
            DispatchQueue.main.async {
                failure(errorMessage)
            }
        }
    }
    
    func getWikiPageURL(page : WikiPage, success:@escaping (String)->Void, failure:@escaping (String)->Void)->Void{
        if let url = page.pageURL{
            success(url)
        }else{
            if let pageID = page.pageID{
                let url = "\(pageURL)\(pageID)"
                NetworkInterface .callGetApi(urlString: url, success: { (json) in
                    var flag = false
                    if let json = json{
                        let query:Dictionary<String,Any>? = json["query"] as? Dictionary<String, Any>
                        if let query = query{
                            let pages:Array<Dictionary<String,Any>>? = query["pages"] as? Array<Dictionary<String,Any>>
                            if let pages = pages, pages.count>0{
                                let pageid:Dictionary<String,Any> = pages[0]
                                let fullURL:String? = pageid["fullurl"] as? String
                                if let fullURL = fullURL{
                                    page.pageURL = fullURL
                                    flag = true
                                    DispatchQueue.main.async {
                                        success(fullURL)
                                    }
                                }
                                
                            }
                        }
                    }
                    if !flag {
                        DispatchQueue.main.async {
                            failure("No Data Found")
                        }
                    }
                }) { (errorMessage) in
                    DispatchQueue.main.async {
                        failure(errorMessage)
                    }
                }
            }
            else {failure("No Page ID Found")}
        }

    }
    
    func savePageData(page : WikiPage){
        self.saveWikiPageOffline(wpage: page, success: {
        }, failure: { (errorMessage) in
        })
    }
    
    
    func getDataFromPageOnline(page: WikiPage)->URLRequest?{
        if let url = page.pageURL{
            let uri = URL.init(string: url)
            if let uri = uri{
                var request = URLRequest.init(url: uri, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 35)
                request.httpMethod="GET"
                let session:URLSession=URLSession.init(configuration: URLSessionConfiguration.default)
                let task = session.dataTask(with: request) { (data, response, error) in}
                task.resume()
                return request
            }
        }
        return nil
    }
    
    
    func getDataFromPageOffline(page: WikiPage)->Data?{
        if let url = page.pageURL{
            let uri = URL.init(string: url)
            if let uri = uri{
                var request = URLRequest.init(url: uri, cachePolicy: URLRequest.CachePolicy.returnCacheDataDontLoad, timeoutInterval: 35)
                request.httpMethod="GET"
                let response = URLCache.shared.cachedResponse(for: request)
                if let response = response{
                    let data = response.data
                    return data
                }
            }
        }
        return nil
    }
    
    
    
    
    
    
    
    

}
