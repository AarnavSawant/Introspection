//
//  SignInViewController.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/18/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import CryptoKit
import FirebaseAuth
import FBSDKCoreKit
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import FirebaseFirestore
import FBSDKLoginKit
import FBSDKCoreKit
class SignInViewController: UIViewController, GIDSignInDelegate, ASAuthorizationControllerPresentationContextProviding, LoginButtonDelegate {
    
    
    
//    @IBOutlet weak var FBloginButton: FBLoginButton!
    var currentNonce: String?
    @IBOutlet weak var appleButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {

        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self

        // Automatically sign in the user.
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        GIDSignIn.sharedInstance()?.delegate = self
                GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
//    func setupView() {
//        let
//    }
    @objc func appleSignInTapped() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        self.currentNonce = randomNonceString()
        request.nonce = sha256(currentNonce!)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User Logged Out")
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
//        print("Real Madrid", error!.localizedDescription)
        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.tokenString)!)
        let db = Firestore.firestore()
        Auth.auth().signIn(with: credential) { (authResult, err) in
            if err == nil {
                print("Firebase Log In Done Successful")
                db.collection("users").document(authResult!.user.uid).setData(["display_name" : authResult!.user.displayName, "uid" : authResult!.user.uid]) { (error) in
                    if error != nil {
                        print("Name not captured")
                    }
                }
                self.transitionToHomeScreen()
            } else {
                print("Error", err!.localizedDescription)
            }
        }
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
//                    let email = user.profile.email
                    UserDefaults.standard.set(authResult.user.uid, forKey: "uid")
                    UserDefaults.standard.set(true, forKey: "signed_in")
    //                UserDefaults.standard.set(
                //                        if user.isEmailVerified {
                    db.collection("users").document(authResult.user.uid).setData(["first_name" : first_name, "last_name" : last_name, "uid" : authResult.user.uid]) { (error) in
                        if error != nil {
                            print("Name not captured")
                        }
                    }
                    self.transitionToHomeScreen()

            }
        }
    }
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
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

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authentication Error")
        guard let error = error as? ASAuthorizationError else {
            return
        }
        print(error.localizedDescription)
        switch error.code {
            case .canceled:
                print("User pressed Cancel")
            case .unknown:
                print("Unknown Error")
            case .invalidResponse:
                print("Invalid Response")
            case .notHandled:
                print("Not Handled")
            case .failed:
                print("Authentication Failed")
        @unknown default:
                print("Default Error")
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("The BEARS STILL SUCK")
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential{
            UserDefaults.standard.set(credential.user, forKey: "appleIDUserCredential")
            guard let nonce = currentNonce else {
                fatalError("Login Callback Received, but No Login Request")
            }
            guard let idToken = credential.identityToken else {
                print("Failed to get ID Token")
                return
            }
            guard let idTokenString = String(data: idToken, encoding: .utf8)  else {
                print("Failed to get ID Token")
                return
            }
            let db = Firestore.firestore()
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: firebaseCredential) { (result, err) in
                UserDefaults.standard.set(result!.user.uid, forKey: "uid")
                UserDefaults.standard.set(true, forKey: "signed_in")
                db.collection("users").document(result!.user.uid).setData(["first_name" : credential.fullName!.givenName, "last_name" : credential.fullName!.familyName, "uid" : result!.user.uid]) { (error) in
                    if error != nil {
                        print("Name not captured")
                    }
                }
                if err != nil {
                    print("Created User")
                }
            }
            transitionToHomeScreen()
        }
        
    }
}
