//
//  AnalyticsHomeViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/21/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class AnalyticsHomeViewController: UIViewController {
    @IBOutlet weak var breakdownButton: UIButton!
    @IBOutlet weak var MonthlyButton: UIButton!
    @IBOutlet weak var YearlyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    
    override func viewDidLoad() {
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
    @IBAction func didPressWeeklyButton(_ sender: Any) {
    }
    
    @IBAction func didClickYearlyButton(_ sender: Any) {
    }
    @IBAction func didClickBreakdownButton(_ sender: Any) {
    }
    @IBAction func MonthlyButton(_ sender: Any) {
    }
}
