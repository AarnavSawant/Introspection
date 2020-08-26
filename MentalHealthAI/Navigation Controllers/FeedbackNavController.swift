//
//  FeedbackNavController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/14/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class FeedbackNavController: UINavigationController {
    var inputText: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)

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
