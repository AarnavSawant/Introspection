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
import FirebaseFirestore
class UserProfileViewController: UIViewController {
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var assistantView: UIView!
    @IBOutlet weak var aboutAppStackView: UIStackView!
    @IBOutlet weak var notificationsEnabledSwitch: UISwitch!
    @IBOutlet weak var DailyReflectLabel: UILabel!
//    @IBOutlet weak var NotificationTimeButton: UIButton!
    @IBOutlet weak var PPButton: UIButton!
    @IBOutlet weak var TandCButton: UIButton!
    @IBOutlet weak var AboutUsButton: UIButton!
    @IBOutlet weak var logInMethodLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var notificationTextField: UITextField!
//    @IBOutlet weak var notificationTime: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        let url = Auth.auth().currentUser?.photoURL
        if url != nil {
            if let data = try? Data(contentsOf: url!) {
                profileImage.image = UIImage(data: data)
            }
        }
        let db = Firestore.firestore()
        if UserDefaults.standard.string(forKey: "NotificationTime") != nil {
            if UserDefaults.standard.string(forKey: "NotificationTime") != "NOT ENABLED" {
                notificationTextField.text = UserDefaults.standard.string(forKey: "NotificationTime")
            }
        }
        profileImage.layer.cornerRadius = 0.5 * profileImage.frame.width
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
        notificationsEnabledSwitch.onTintColor =  UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1)
        signOutButton.setTitleColor(UIColor(red: 0.216, green: 0.447, blue: 1, alpha: 1), for: .normal)
        image.frame = CGRect(x: navView.center.x, y: navView.center.y - 20, width: 22.73, height: 11.04)
        view.backgroundColor = .white
        image.contentMode = UIView.ContentMode.scaleAspectFit
        logInMethodLabel.text = " "
        navView.addSubview(label)
        navView.addSubview(image)
        let logInMethod = UserDefaults.standard.string(forKey: "sign_in_method")
//        if (logInMethod != nil) {
        if logInMethod != nil {
            logInMethodLabel.text = "Signed In with \(logInMethod!)"
        }
//        }
        self.navigationItem.titleView = navView
        emailLabel.alpha = 0.6
        emailLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        logInMethodLabel.alpha = 0.6
        logInMethodLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        notificationTextField.alpha = 0.6
        notificationTextField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.emailLabel.text = Auth.auth().currentUser!.email ?? ""
        self.nameLabel.text = Auth.auth().currentUser!.displayName ?? ""
        
        assistantView.backgroundColor = .white
        assistantView.layer.cornerRadius = 10
        self.view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        super.viewDidLoad()
//        createDatePicker()
//        NotificationTimeButton.contentHorizontalAlignment = .left
        notificationView.layer.cornerRadius = 10
        PPButton.backgroundColor = .none
        PPButton.contentHorizontalAlignment = .left
        TandCButton.contentHorizontalAlignment = .left
        TandCButton.backgroundColor = .none
        signOutButton.layer.cornerRadius = 10
        signOutButton.backgroundColor = .white
        AboutUsButton.contentHorizontalAlignment = .left
        AboutUsButton.backgroundColor = .none
//        var datePicker: UIDatePicker = UIDatePicker()
        var toolbar = UIToolbar()
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
        datePicker.addTarget(self, action: #selector(notificationTimeChanged), for: UIControl.Event.valueChanged)
        toolbar.setItems([doneButton], animated: true)
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = UIColor.white
        notificationTextField.inputView = datePicker
        notificationTextField.inputAccessoryView = toolbar
//        notificationTextField.isUserInteractionEnabled = false
//        datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        
    
        // Do any additional setup after loading the view.
    }
//    func createDatePicker() {
//        datePicker.datePickerMode = .time
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonPressed))
//        toolbar.setItems([doneButton], animated: true)
//        notificationTime.inputAccessoryView = toolbar
//        notificationTime.inputView = datePicker
//    }
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
//        UNUserNotificationCenter.current()
        if notificationsEnabledSwitch.isOn {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            let date = dateFormatter.date(from: notificationTextField.text!)
//            let db = Firestore.firestore()
            UserDefaults.standard.set(notificationTextField.text!, forKey: "NotificationTime")
//            UserDefaults.standard.set(false, forKey: "changeLocalNotifications")
            var components = DateComponents()
            let calendar = Calendar.current.dateComponents([.hour, .minute], from: date!)
            components.hour = calendar.hour
            components.minute = calendar.minute
            var content = UNMutableNotificationContent()
            content.title = "It's Time to Introspect!"
            content.body = "Take a step back from your day and reflect!"
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(identifier: "IntrospectionNotification", content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            center.add(request)
            self.view.endEditing(true)
        } else {
            let alertController = UIAlertController(title: "Turn On the Notification Switch", message: "Turn On the Notification Switch Above to receive daily notifications", preferredStyle: UIAlertController.Style.alert)


            let cancelAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
            alertController.addAction(cancelAction)
            self.view.endEditing(true)
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
    }
    @objc func notificationTimeChanged(sender:UIDatePicker){
        print("WAKANDA")
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle  = DateFormatter.Style.short
        dateFormatter.dateFormat = "h:mm a"
        self.notificationTextField.text = dateFormatter.string(from: sender.date)
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
    @IBAction func switchValuesDidChange(_ sender: UISwitch) {
        print("VALUE CHANGED")
        if (sender.isOn) {
            if UIApplication.shared.isRegisteredForRemoteNotifications {
                var content = UNMutableNotificationContent()
                content.title = "It's Time to Introspect!"
                content.body = "Take a step back from your day and reflect!"
                var dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                var components = DateComponents()
                let date = dateFormatter.date(from: self.notificationTextField.text!)!
                UserDefaults.standard.set(notificationTextField.text!, forKey: "NotificationTime")
                let calendar = Calendar.current.dateComponents([.hour, .minute], from: date)
                let center = UNUserNotificationCenter.current()
                components.hour = calendar.hour
                components.minute = calendar.minute
    //            UNNotificationRequest
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true).self
                let request = UNNotificationRequest(identifier: "IntrospectionNotification", content: content, trigger: trigger)
                center.add(request) { (err) in
                    if err == nil {
                        print("Notification Created")
                    }
                }
            } else {
                sender.isOn = false
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                UserDefaults.standard.set("NOT ENABLED", forKey: "NotificationTime")
                let alertController = UIAlertController(title: "Permission needed for Notifications", message: "Please enable notifications in settings.", preferredStyle: UIAlertController.Style.alert)

                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })

                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
                alertController.addAction(cancelAction)

                alertController.addAction(okAction)

                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UserDefaults.standard.set("NOT ENABLED", forKey: "NotificationTime")
//            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        }
    }
    
}
