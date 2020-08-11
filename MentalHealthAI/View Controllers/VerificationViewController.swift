//
//  VerificationViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/10/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
class VerificationViewController: UIViewController {

    @IBOutlet weak var verificationLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: "checkIfUserVerified", name: UIApplication.willEnterForegroundNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func checkIfUserVerified() {
        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil {
                print("JAMES RODRIGUEZ")
            }
            if (Auth.auth().currentUser?.isEmailVerified)! {
                print("PIZZA")
                self.transitionToHomeScreen()
                
            }
        })
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
