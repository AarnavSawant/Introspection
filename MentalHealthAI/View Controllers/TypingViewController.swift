//
//  TypingViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 10/23/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit

class TypingViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var TranscribedText: UITextView!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = .white
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
        TranscribedText.delegate = self

        self.navigationItem.titleView = navView
        var barButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonPressed))
        let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: nil, action: #selector(submitButtonPressed))
        self.navigationItem.rightBarButtonItem = submitButton
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationItem.titleView?.backgroundColor = UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([doneButton], animated: true)
        TranscribedText.inputAccessoryView = toolbar
        navView.sizeToFit()
        super.viewDidLoad()
        TranscribedText.sizeToFit()
        TranscribedText.textColor = .lightGray
        TranscribedText.text = "Type your reflection here!"
        

        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView) {
//        print("SUCK ON MY COCK")
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("SUCK ON MY DICK")
        if TranscribedText.textColor  == UIColor.lightGray {
            TranscribedText.text = nil
            TranscribedText.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if TranscribedText.text.isEmpty || TranscribedText.text == "" {
            TranscribedText.textColor = .lightGray
            TranscribedText.text = "Type your reflection here!"
        }
    }
    @objc func doneButtonPressed() {
        self.view.endEditing(true)
        
    }
    @objc func backButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submitButtonPressed() {
        print("PIZZA", TranscribedText.text!)
        let words = TranscribedText.text!.components(separatedBy: " ").count
        if words >= 8 {
//            print(TranscribedText.text!.count)
            let results_nav_vc = storyboard?.instantiateViewController(identifier: "results_nav") as! ResultsNavController
            results_nav_vc.text = TranscribedText.text
            results_nav_vc.modalPresentationStyle = .fullScreen
            self.present(results_nav_vc, animated: true, completion: nil)
        } else if words < 8 || TranscribedText.text.isEmpty {
            let alertController = UIAlertController(title: "Please type at least 8 words", message: "It helps us detect your emotion more accurately.", preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(alertAction)

            //            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
            //                //Redirect to Settings app
            //                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            //            })


            //            alertController.addAction(okAction)

                        self.present(alertController, animated: true, completion: nil)
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
