//
//  UserFeedbackViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/28/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
class UserFeedbackViewController: UIViewController {
    public var selectedEmotion: String?
    @IBOutlet weak var happyButton: UIButton!
    public var inputText: String?
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feedbackTextField: UITextField!
    @IBOutlet weak var helpMeLearnLabel: UILabel!
    @IBOutlet weak var submitLabel: UILabel!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var fearButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var neutralButton: UIButton!
    @IBOutlet weak var angerButton: UIButton!
    override func viewDidLoad() {
        
        cancelButton.layer.cornerRadius = 0.5 * cancelButton.frame.width
        submitButton.layer.cornerRadius = 0.5 * submitButton.frame.width
        super.viewDidLoad()
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
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

                image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
                view.backgroundColor = .white
                image.contentMode = UIView.ContentMode.scaleAspectFit

                navView.addSubview(label)
                navView.addSubview(image)

                self.navigationItem.titleView = navView

                navView.sizeToFit()
            helpMeLearnLabel.backgroundColor = .white
            helpMeLearnLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
            questionLabel.alpha = 0.6
            questionLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
            questionLabel.font = UIFont(name: "SFProText-Regular", size: 18)
//            feedbackTextField.backgroundColor = .white

            feedbackTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
            feedbackTextField.layer.cornerRadius = 10
            feedbackTextField.layer.borderWidth = 1
            feedbackTextField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
//            cancelButton.backgroundColor = .white
        let navController = self.navigationController as! FeedbackNavController
        inputText = navController.inputText
        print("Input Text", inputText)
        cancelButton.alpha = 0.05
            cancelButton.backgroundColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        
//            submitButton.backgroundColor = .white

            submitButton.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        cancelLabel.alpha = 0.6
        cancelLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        cancelLabel.font = UIFont(name: "SFProText-Medium", size: 18)
//        cancelButton.backgroundColor = .white
//        submitButton.backgroundColor = .white

        submitLabel.alpha = 0.6
        submitLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        submitLabel.font = UIFont(name: "SFProText-Medium", size: 18)
        happyButton.layer.cornerRadius = 8
       sadButton.layer.cornerRadius = 8
       angerButton.layer.cornerRadius = 8
        fearButton.layer.cornerRadius = 8
        neutralButton.layer.cornerRadius = 8

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didClickHappyButton(_ sender: Any) {
        fearButton.layer.backgroundColor = UIColor.white.cgColor
        
        neutralButton.layer.backgroundColor = UIColor.white.cgColor
        sadButton.layer.backgroundColor = UIColor.white.cgColor
        angerButton.layer.backgroundColor = UIColor.white.cgColor
//        happyButton.layer.borderColor = UIColor.blue.cgColor
//        happyButton.alpha = 0.2
        happyButton.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.45).cgColor
//        happyButton.layer.borderWidth = 3.0
        selectedEmotion = "joy"
        
    }
    
    @IBAction func didClickAngerButton(_ sender: Any) {
        fearButton.layer.backgroundColor = UIColor.white.cgColor
        neutralButton.layer.backgroundColor = UIColor.white.cgColor
        sadButton.layer.backgroundColor = UIColor.white.cgColor
        happyButton.layer.backgroundColor = UIColor.white.cgColor
        angerButton.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.45).cgColor
//        angerButton.layer.borderWidth = 3.0
        selectedEmotion = "anger"
    }
    
    @IBAction func didClickFearButton(_ sender: Any) {
        angerButton.layer.backgroundColor = UIColor.white.cgColor
        neutralButton.layer.backgroundColor = UIColor.white.cgColor
        sadButton.layer.backgroundColor = UIColor.white.cgColor
        happyButton.layer.backgroundColor = UIColor.white.cgColor
        fearButton.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.45).cgColor
//        fearButton.layer.borderWidth = 3.0
        selectedEmotion = "fear"
    }
    @IBAction func didClickNeutralButton(_ sender: Any) {
        fearButton.layer.backgroundColor = UIColor.white.cgColor
        angerButton.layer.backgroundColor = UIColor.white.cgColor
        sadButton.layer.backgroundColor = UIColor.white.cgColor
        happyButton.layer.backgroundColor = UIColor.white.cgColor
        neutralButton.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.45).cgColor
//        neutralButton.layer.borderWidth = 3.0
        selectedEmotion = "neutral"
    }
    @IBAction func didClickSadButton(_ sender: Any) {
        fearButton.layer.backgroundColor = UIColor.white.cgColor
        neutralButton.layer.backgroundColor = UIColor.white.cgColor
        angerButton.layer.backgroundColor = UIColor.white.cgColor
        happyButton.layer.backgroundColor = UIColor.white.cgColor
        sadButton.layer.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.45).cgColor
//        sadButton.layer.borderWidth = 3.0
        selectedEmotion = "sadness"
    }
    @IBAction func didClickCancelButton(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didClickSubmitButton(_ sender: Any) {
        if selectedEmotion == nil {
            let alertController = UIAlertController(title: "Emotion Needs to be Selected", message: "Please select an emotion before pressing submit", preferredStyle: UIAlertController.Style.alert)

//            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
//                //Redirect to Settings app
//                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
//            })

            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)

//            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)
        } else {
            let db = Firestore.firestore()
            db.collection("feedback").addDocument(data: ["text" : inputText!, "emotion" : selectedEmotion, "feedback" : feedbackTextField.text!, "user_id" : UserDefaults.standard.string(forKey: "uid")]) { (err) in
                if err == nil {
                    print("Success")
                }
            }
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
            
        }
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
