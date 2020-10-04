//
//  AboutUsViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/29/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutMeLabel: UILabel!
    @IBOutlet weak var missionStatementLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    override func viewDidLoad() {
        Analytics.logEvent("entered_AboutUs_Screen", parameters: nil)
        let navView = UIView()
        let label = UILabel()
        aboutMeLabel.text = "Hi! My name is Aarnav and I am the founder of Introspection.  From a very young age, I have always been fascinated by how data and technology can help humanity. My Dad’s work in AI further accelerated my interest and journey to explore the world of AI.\n\nMy early work started with projecting NFL statistics and making English Premier League game predictions before continuing with games such as online Poker. Since last year, I have focused more on Deep Learning and have worked on projects such as Wildfire Detection and COVID-19 Sentiment Trends and Forecasting, while also programming for my robotics team at school. The COVID-19 pandemic personally impacted me, preventing me from hanging out with friends, playing soccer, and travelling.\n\nOne thing we always do as a family before we go to bed is to summarize our day, which helps us to stay positive and remain focused. I wanted to use my knowledge of AI to share our tradition with you all by creating a fun, simple and insightful product for you to use.\n\nIntrospection is a contemporary twist on the typical journaling app, providing users with instant gratification and actionable insights. Introspection hopes to provide people with the opportunity to slow down from this rapidly advancing world and take a second to reflect on what’s truly important, their emotional well-being."
        label.text = "About Us"
        label.sizeToFit()
        label.center = navView.frame.origin

//        let image = UIImageView()
//        image.image = UIImage(named: "Infinity")
        label.frame.size.width = 150
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
//        self.navigationItem.backBarButtonItem?.setTitleTextAttributes(NSAttributedString.Key.tit, for: <#T##UIControl.State#>)
        super.viewDidLoad()
        subtitleLabel.backgroundColor = .white
        missionStatementLabel.backgroundColor = .white

        subtitleLabel.alpha = 0.6
        subtitleLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        missionStatementLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
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
