//
//  WikiPage.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class WikiPage: NSObject {

    var pageID : String?
    var image : String?
    var pageData : Data?
    var title : String?
    var pageDescription : String!
    var timestamp : Date!
    var pageURL : String?
    
    convenience init(page: Page){
        self.init()
        pageID = page.page_id
        title = page.title
        image = page.image
        pageDescription = page.page_desciption
        pageData = page.page_data
        timestamp = page.timestamp
        pageURL = page.page_url
    }
    
    
    convenience init(page: Dictionary<String,Any>){
        self.init()
        let pid = page["pageid"]
        if let pid = pid{
            print(pid)
            pageID = "\(pid)"
        }
        
        title = page["title"] as? String
        let thumbnail:Dictionary<String,Any>? = page["thumbnail"] as? Dictionary<String,Any>
        if let thumbnail=thumbnail{
            image = thumbnail["source"] as? String
        }
        
        let terms:Dictionary<String,Any>? = page["terms"] as? Dictionary<String,Any>
        if let terms=terms{
            let description:Array<String>? = terms["description"] as? Array<String>
            if let description=description{
                pageDescription = description[0]
            }
        }
        timestamp = Date.init()
    }
    
    
    
}
