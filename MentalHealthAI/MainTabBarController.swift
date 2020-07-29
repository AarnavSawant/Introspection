//
//  MainTabBarController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/12/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    public var emailAddress: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.selectedIndex = 1
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
