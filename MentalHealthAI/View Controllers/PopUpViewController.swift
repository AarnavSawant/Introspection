////
////  PopUpViewController.swift
////  MentalHealthAI
////
////  Created by Parikshat Sawant on 7/28/20.
////  Copyright © 2020 Sawant,Inc. All rights reserved.
////
//
//import UIKit
//
//class PopUpViewController: UIViewController {
//    
//    var inputText: String?
//    @IBOutlet weak var deleteButton: UIButton!
//    @IBOutlet weak var popUpView: UIView!
//    @IBOutlet weak var cancelButton: UIButton!
//    override func viewDidLoad() {
////        deleteButton.layer.borderWidth = 2
////        deleteButton.layer.cornerRadius = 0.05 * deleteButton.frame.width
////        deleteButton.layer.borderColor = UIColor.gray.cgColor
//        super.viewDidLoad()
//        popUpView.layer.cornerRadius = 0.05 * popUpView.frame.width
//
//        // Do any additional setup after loading the view.
//    }
//    
////    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "feedback" {
////
////        }
////    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.destination is FeedbackViewController {
//            let vc = segue.destination as? FeedbackViewController
//            vc?.inputText = inputText ?? "Hello"
//        }
//    }
//    @IBAction func didClickCancelButton(_ sender: Any) {
//        self.dismiss(animated: false) {
//            self.dismiss(animated: false, completion: nil)
//        }
//    }
//    @IBAction func didClickDeleteButton(_ sender: Any) {
//    
//        
//    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
