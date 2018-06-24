//
//  OnboardingViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 24/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    @IBOutlet weak var onboardingView: OnboardingView!
    

    @IBOutlet weak var getStartedButton: UIButton!
    
    static func getInstance()->UIViewController{
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1:OnboardingViewController = s.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        return vc1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self;
        onboardingView.delegate = self
        self.getStarted.alpha = 0
    }
    
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let bgcolor1 = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let bgcolor2 = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let bgcolor3 = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "wiki-1"),
                               title: "Explore Wikipedia",
                               description: "Search across Wikipedia, a free online encyclopedia created and edited by volunteers around the world",
                               pageIcon: #imageLiteral(resourceName: "wiki-1"),
                               color: bgcolor1,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 17),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "offline"),
                               title: "Offline Mode",
                               description: "All your searches are cached so that you can revisit them even when you are not connected to internet",
                               pageIcon: #imageLiteral(resourceName: "offline"),
                               color: bgcolor2,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 17),
                               descriptionFont: UIFont.systemFont(ofSize: 14)),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "recent"),
                               title: "Recent Searches",
                               description: "View your recent searches and revisit them.",
                               pageIcon: #imageLiteral(resourceName: "recent"),
                               color: bgcolor3,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: UIFont.systemFont(ofSize: 17),
                               descriptionFont: UIFont.systemFont(ofSize: 14))
            ][index]
    }
    
    
    func onboardingWillTransitonToIndex(_ index : Int) {
        if index == 1{
            if self.getStartedButton.alpha == 1{
                UIView.animate(withDuration: 0.2) {
                    self.getStartedButton.alpha = 0;
                }
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index : Int) {
        if index == 2{
                UIView.animate(withDuration: 0.4) {
                    self.getStartedButton.alpha = 1;
                }
        }
    }
    

    
    
    

    @IBOutlet weak var getStarted: UIButton!
    
    @IBAction func getStarted(_ sender: Any) {
        self.present(ExploreViewController.getInstance(), animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
