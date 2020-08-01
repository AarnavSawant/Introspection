//
//  SignUpViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class SignUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9]).{8,}$")
        return passwordTest.evaluate(with: password)
    }
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter all fields"
        }
        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if !isPasswordValid(cleanedPassword!) {
            return "Password has to be at least 8 characters long and contains 2 uppercase letters, 1 special case letter, and 2 digits."
        }
        return nil
    }
        
    
    
    @IBAction func didClickSignUpButton(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            let first_name = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let last_name = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    print(err?.localizedDescription)
                    self.showError("Error creating User")
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").document(email).setData(["first_name" : first_name, "last_name" : last_name, "uid" : result?.user.uid]) { (err) in
                        if err != nil {
                            print("Name not captured")
                        }
                    }
                    UserDefaults.standard.set(true, forKey: "signed_in")
                    UserDefaults.standard.set(self.emailTextField.text, forKey: "emailAddress")
                    self.transitionToHomeScreen()
                    
                }
            }
        
        }
    }
    
    
    func showError(_ message: String) {
//        erro
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHomeScreen() {
//        let constants = Constants()
//        Constants.emailAddress = emailTextField.text
        let vc = storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
//        vc!.emailAddress = emailTextField.text
//        let question_vc = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController
//        vc!.emailAddress = emailTextField.text
//        question_vc!.email = emailTextField.text
        view.window?.rootViewController = vc
        view.window?.makeKeyAndVisible()
        
        
    }
    
}