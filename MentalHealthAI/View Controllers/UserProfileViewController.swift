//
//  UserProfileViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/3/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
class UserProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickSignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(false, forKey: "signed_in")
        UserDefaults.standard.set("", forKey: "emailAddress")
        transitionToSignInScreen()
    }
    func transitionToSignInScreen() {
        let vc = storyboard?.instantiateViewController(identifier: "signInHome") as? FirstViewController
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
