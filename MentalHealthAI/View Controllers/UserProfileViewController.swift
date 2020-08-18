//
//  UserProfileViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 8/3/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//
import UserNotifications
import UIKit
import FirebaseAuth
class UserProfileViewController: UIViewController {

    @IBOutlet weak var notificationTime: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    
        // Do any additional setup after loading the view.
    }
    func createDatePicker() {
        datePicker.datePickerMode = .time
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        notificationTime.inputAccessoryView = toolbar
        notificationTime.inputView = datePicker
    }
    @IBAction func didClickSignOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(false, forKey: "signed_in")
        UserDefaults.standard.set("", forKey: "uid")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("SIGNED IN USER", UserDefaults.standard.bool(forKey: "signed_in"))
            self.transitionToSignInScreen()
        }
    }
    @objc func doneButtonPressed() {
        print("Hello")
        let calendar = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
        
        notificationTime.text = "\(calendar.hour!):\(calendar.minute!)"
        let content = UNMutableNotificationContent()
        content.title = "Click here to Introspect"
        content.subtitle = "GO PACK GO"
        print("Hello")
        let calendar2 = Calendar.current.dateComponents([.day, .year, .month, .hour, .minute, .second], from: datePicker.date)
               
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar2, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if err == nil {
                print("Success creating Notification")
            }
        }
        self.view.endEditing(true)
        
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
