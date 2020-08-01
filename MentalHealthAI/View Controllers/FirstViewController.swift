//
//  FirstViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "signed_in") {
            transitionToHomeScreen()
        }
    }
    
    func transitionToHomeScreen() {
        let vc = storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
//        UserDefaults.standard.set(emailTextField.text, forKey: "emailAddress")
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
        
        
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
