//
//  AnalyticsHomeViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/21/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class AnalyticsHomeViewController: UIViewController {
    @IBOutlet weak var breakdownButton: UIButton!
    @IBOutlet weak var MonthlyButton: UIButton!
    @IBOutlet weak var thisMonthLabel: UILabel!
    @IBOutlet weak var thisYearLabel: UILabel!
    @IBOutlet weak var theBreakdownLabel: UILabel!
    @IBOutlet weak var thisWeekLabel: UILabel!
    @IBOutlet weak var YearlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    

    
    override func viewDidLoad() {
        
//        layer0.shadowOpacity = 1
//        layer0.shadowRadius = 4
//        layer0.shadowOffset = CGSize(width: 0, height: 1)
//        layer0.bounds = shadows.bounds
//        layer0.position = shadows.center
//        shadows.layer.addSublayer(layer0)

//        var shapes = UIView()
//        shapes.frame = view.frame
//        shapes.clipsToBounds = true
//        MonthlyButton.addSubview(shapes)

//        let layer1 = CALayer()
//        layer1.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
//        layer1.bounds = shapes.bounds
//        layer1.position = shapes.center
//        shapes.layer.addSublayer(layer1)

//        shapes.layer.cornerRadius = 10
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Analytics.logEvent("entered_Analytics_Screen", parameters: nil)
        let navView = UIView()
        let label = UILabel()
        label.text = "introspection"
        label.sizeToFit()
        label.center = navView.frame.origin

        let image = UIImageView()
        image.image = UIImage(named: "Infinity")
        label.frame.size.width = 150
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Heavy", size: 18)
//        notificationsEnabledSwitch.onTintColor =  UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
//        signOutButton.setTitleColor(UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1), for: .normal)
        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
        view.backgroundColor = .white
        image.contentMode = UIView.ContentMode.scaleAspectFit

        navView.addSubview(label)
        navView.addSubview(image)
//        let logInMethod = UserDefaults.standard.string(forKey: "sign_in_method")
//        logInMethodLabel.text = "Signed In with \(logInMethod!)"
        self.navigationItem.titleView = navView
        
        var lastSundayDate = Calendar.current.date(byAdding: .day, value: -Calendar.current.component(.weekday, from: Date()) + 1, to: Date())
        var nextSundayDate = Calendar.current.date(byAdding: .day, value: 7, to: lastSundayDate!)
         var df = DateFormatter()
        df.dateFormat = "MMM dd"
        thisWeekLabel.text = "\(df.string(from: lastSundayDate!))-\(df.string(from: nextSundayDate!))"
        df.dateFormat = "MMMM, yyyy"
        thisMonthLabel.text = df.string(from: Date())
        
        df.dateFormat = "yyyy"
        thisYearLabel.text = df.string(from: Date())
        theBreakdownLabel.text = df.string(from: Date())
        MonthlyButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        MonthlyButton.layer.shadowRadius = 4
        MonthlyButton.layer.shadowOpacity = 1.0
        MonthlyButton.layer.cornerRadius = 10
        
        YearlyButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        YearlyButton.layer.shadowRadius = 4
        YearlyButton.layer.shadowOpacity = 1.0
        YearlyButton.layer.cornerRadius = 10
        
        weeklyButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        weeklyButton.layer.shadowRadius = 4
        weeklyButton.layer.shadowOpacity = 1.0
        weeklyButton.layer.cornerRadius = 10
        
        breakdownButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        breakdownButton.layer.shadowRadius = 4
        breakdownButton.layer.shadowOpacity = 1.0
        breakdownButton.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func didPressWeeklyButton(_ sender: Any) {
    }
    
    @IBAction func didClickYearlyButton(_ sender: Any) {
    }
    @IBAction func didClickBreakdownButton(_ sender: Any) {
    }
    @IBAction func MonthlyButton(_ sender: Any) {
    }
}
