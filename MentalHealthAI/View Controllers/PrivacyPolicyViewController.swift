//
//  PrivacyPolicyViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/31/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class PrivacyPolicyViewController: UIViewController {
    @IBOutlet weak var ppButton: UILabel!
    
    override func viewDidLoad() {
        Analytics.logEvent("entered_PrivacyPolicy_Screen", parameters: nil)
        ppButton.textColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        let navView = UIView()
                  let label = UILabel()
                  label.text = "Privacy Policy"
                  label.sizeToFit()
                  label.center = navView.frame.origin

          //        let image = UIImageView()
          //        image.image = UIImage(named: "Infinity")
                  label.frame.size.width = 300
                  label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                  label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)
          //        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
                  navView.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
          //        navView.tintColor = .green
          //        image.contentMode = UIView.ContentMode.scaleAspectFit

                  navView.addSubview(label)
          //        navView.addSubview(image)

                  self.navigationItem.titleView = navView
                  self.navigationItem.titleView?.tintColor = .white
                  self.navigationController?.navigationBar.tintColor = .white
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
