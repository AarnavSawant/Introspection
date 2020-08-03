//
//  SignInViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore
class SignInViewController: UIViewController, GIDSignInDelegate {
   
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.delegate = self
                GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Signed In", UserDefaults.standard.bool(forKey: "signed_in"))
        if UserDefaults.standard.bool(forKey: "signed_in") {
            transitionToHomeScreen()
        }
    }
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$")
        return passwordTest.evaluate(with: password)
    }
    func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter all fields"
        }
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword!) {
            return "Password has to be at least 8 characters long and contains 2 uppercase letters, 1 special case letter, 2 digits, and 3 lowercase letters."
        }
        return nil
    }
    @IBAction func didClickLogInButton(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            errorLabel.text = error!
        } else {
            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
            }
                UserDefaults.standard.set(self.emailTextField.text, forKey: "emailAddress")
            self.transitionToHomeScreen()
            }
        }
    }
    
    func transitionToHomeScreen() {
        let vc = storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
        
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
          // ...
          if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
              print("The user has not signed in before or they have since signed out.")
            } else {
              print("\(error.localizedDescription)")
            }
            return
          }

          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
                }
                let db = Firestore.firestore()
                if let authResult = authResult {
    //                let user = authResult.user
                    
                    let first_name = user.profile.givenName
                    let last_name = user.profile.familyName
                    let email = user.profile.email
                    UserDefaults.standard.set(email!, forKey: "emailAddress")
                    UserDefaults.standard.set(true, forKey: "signed_in")
    //                UserDefaults.standard.set(
                //                        if user.isEmailVerified {
                    db.collection("users").document(email!).setData(["first_name" : first_name, "last_name" : last_name, "uid" : authResult.user.uid]) { (error) in
                        if error != nil {
                            print("Name not captured")
                        }
                    }
                    self.transitionToHomeScreen()

            }
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
