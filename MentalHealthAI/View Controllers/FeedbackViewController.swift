//
//  FeedbackViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/28/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    var inputText: String?
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    override func viewDidLoad() {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
        super.viewDidLoad()
        popUpView.layer.cornerRadius = 0.05 * popUpView.frame.width
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UserFeedbackViewController {
            let vc = segue.destination as? UserFeedbackViewController
            vc?.inputText = inputText ?? "Hello"
        }
    }
    @IBAction func yesAction(_ sender: Any) {
    }
    @IBAction func noAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
//        let presenting_vc = self.presentingViewController as? ConfirmViewController
//        print(presenting_vc?.TranscribedText.text ?? "No Text")
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
