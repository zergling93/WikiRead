//
//  OnboardingViewController.swift
//  WikiRead
//
//  Created by Gitesh Agarwal on 24/06/18.
//  Copyright © 2018 Gitesh Agarwal. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    
    static func getInstance()->UIViewController{
        let s = UIStoryboard.init(name: "Main", bundle: nil)
        let vc1:OnboardingViewController = s.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
        return vc1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let onboarding = PaperOnboarding(itemsCount: 3)
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        
        for attribute: NSLayoutAttribute in [.Left, .Right, .Top, .Bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .Equal,
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
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
