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
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var assistantView: UIView!
    @IBOutlet weak var aboutAppStackView: UIStackView!
    @IBOutlet weak var notificationsEnabledSwitch: UISwitch!
    @IBOutlet weak var DailyReflectLabel: UILabel!
    @IBOutlet weak var NotificationTimeButton: UIButton!
    @IBOutlet weak var PPButton: UIButton!
    @IBOutlet weak var TandCButton: UIButton!
    @IBOutlet weak var AboutUsButton: UIButton!
    @IBOutlet weak var logInMethodLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var notificationTime: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        assistantView.backgroundColor = .white
        assistantView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        super.viewDidLoad()
        createDatePicker()
        NotificationTimeButton.contentHorizontalAlignment = .left
        notificationView.layer.cornerRadius = 10
        PPButton.backgroundColor = .none
        PPButton.contentHorizontalAlignment = .left
        TandCButton.contentHorizontalAlignment = .left
        TandCButton.backgroundColor = .none
        signOutButton.layer.cornerRadius = 10
        signOutButton.backgroundColor = .white
        AboutUsButton.contentHorizontalAlignment = .left
        AboutUsButton.backgroundColor = .none
        
    
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
        UserDefaults.standard.set(nil, forKey: "calendar_dictionary")
        UserDefaults.standard.set(true, forKey: "should_query")
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
        content.title = "Don't Forget to Introspect!"
        content.subtitle = "GO PACK GO"
        print("Hello")
        var calendar2 = DateComponents()
        let hour = Calendar.current.component(.hour, from: datePicker.date)
        print("DATEEE", datePicker.date)
        let minute = Calendar.current.component(.minute, from: datePicker.date)
        calendar2.hour = hour
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        calendar2.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: calendar2, repeats: true)
        let request = UNNotificationRequest(identifier: "IntrospectionNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if err == nil {
                print("Success creating Notification")
            }
        }
        self.view.endEditing(true)
        
    }
    func transitionToSignInScreen() {
        let vc = storyboard?.instantiateViewController(identifier: "signIn") as? SignInViewController
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
