//
//  MainTabController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 23/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController {

    static var instance : MainTabController?
    
    static func getInstance()->MainTabController{
        if instance == nil{
            instance = MainTabController.init(nibName: nil, bundle: nil)
        }
        return instance!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1 = s.instantiateViewController(withIdentifier: "ExploreViewController")
        let nav1 = UINavigationController.init(rootViewController: vc1)
        let tab1 = nav1.tabBarItem
        tab1!.title = "Explore"
        
        
        let vc2 = s.instantiateViewController(withIdentifier: "BookmarkViewController")
        let nav2 = UINavigationController.init(rootViewController: vc2)
        let tab2 = nav2.tabBarItem
        tab2!.title = "Bookmarks"
        
        self.viewControllers = [nav1,nav2]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
