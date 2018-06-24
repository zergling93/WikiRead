//
//  OnboardingViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 24/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController {

    
    static func getInstance()->UIViewController{
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1:OnboardingViewController = s.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        return vc1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let onboarding = PaperOnboarding.init()
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutAttribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
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
