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
    
    
    @IBOutlet weak var haveFunLabel: UILabel!
    @IBOutlet weak var introspectionView: UIImageView!
    @IBOutlet weak var welcomeToLabel: UILabel!
    
    @IBOutlet weak var logInImageView: UIImageView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    //    @IBOutlet weak var FBloginButton: FBLoginButton!
    @IBOutlet weak var emailForLinkField: UITextField!
    var currentNonce: String?
    @IBOutlet weak var appleButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var signInButton: GIDSignInButton!
//    @IBOutlet weak var errorLabel: UILabel!
//    @IBOutlet weak var logInButton: UIButton!
//    @IBOutlet weak var passwordTextField: UITextField!
//    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        appleButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        appleButton.backgroundColor = .white

        appleButton.layer.cornerRadius = 11.08
        appleButton.layer.borderWidth = 2
        appleButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        var parent = self.view!
//        parent.addSubview(view)
//        appleButton.translatesAutoresizingMaskIntoConstraints = false
//        appleButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -31).isActive = true
//        appleButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
//        appleButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 34).isActive = true
//        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        introspectionView.frame = CGRect(x: 0, y: 0, width: 228.67, height: 36.67)
        introspectionView.backgroundColor = .white


//        var parent = self.view!
//        parent.addSubview(view)
        introspectionView.translatesAutoresizingMaskIntoConstraints = false
//        introspectionView.widthAnchor.constraint(equalToConstant: 228.67).isActive = true
////        introspectionView.centerXAnchor.constraint(equalTo: parent.centerXAnchor, constant: 0).isActive = true
////        introspectionView.backgroundColor = .yellow
//       introspectionView.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 0).isActive = true
//        introspectionView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 184).isActive = true
        
        haveFunLabel.frame = CGRect(x: 0, y: 0, width: 286, height: 64)
        haveFunLabel.backgroundColor = .white

        haveFunLabel.alpha = 0.6
        haveFunLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        haveFunLabel.font = UIFont(name: "SFProText-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.96

        // Line height: 63 pt
        // (identical to box height)

//        view.textAlignment = .center
//        view.attributedText = NSMutableAttributedString(string: "Track your emotions and have fun.", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])
//
//        var parent = self.view!
//        parent.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
//        view.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -533).isActive = true

//        appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        appleButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 292).isActive = true
//        var view = UILabel()
        googleButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        googleButton.backgroundColor = .white
//        signInButton.style = GIDSignInButtonStyle.init(rawValue: 1)!
        googleButton.layer.backgroundColor = UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1).cgColor
        googleButton.layer.cornerRadius = 11.08
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signInButton.colorScheme = GIDSignInButtonColorScheme.init(rawValue: 0)!
//        signInButton.layer.cornerRadius = 25

//        var parent = self.view!
//        parent.addSubview(view)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
//        googleButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -31).isActive = true
//        googleButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
////        googleButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 34).isActive = true
//        googleButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 363).isActive = true
//

        // Line height: 19 pt


        print("SIGNED IN SignIN", UserDefaults.standard.bool(forKey: "signed_in"))
        logInImageView.frame = CGRect(x: 0, y: 0, width: 488, height: 292.66)
        logInImageView.backgroundColor = .white

        logInImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor

//        var parent = self.view!
//        parent.addSubview(view)
//        logInImageView.translatesAutoresizingMaskIntoConstraints = false
//        logInImageView.widthAnchor.constraint(equalToConstant: 488).isActive = true
//        logInImageView.heightAnchor.constraint(equalToConstant: 292.66).isActive = true
//        logInImageView.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: -94).isActive = true
//        logInImageView.topAnchor.constraint(equalTo: parent.topAnchor, constant: 545).isActive = true
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        facebookButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        facebookButton.backgroundColor = .white

        facebookButton.layer.backgroundColor = UIColor(red: 0.235, green: 0.353, blue: 0.604, alpha: 1).cgColor
        facebookButton.layer.cornerRadius = 11.08

//        var parent = self.view!
//        parent.addSubview(view)
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
//        facebookButton.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -31).isActive = true
//        facebookButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
////        facebookButton.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: 33).isActive = true
//        facebookButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 434).isActive = true
//        facebookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        GIDSignIn.sharedInstance()?.delegate = self
                GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
//        var welcomeToLabel = UILabel()
        welcomeToLabel.frame = CGRect(x: 0, y: 0, width: 152, height: 43)
        welcomeToLabel.backgroundColor = .white

        welcomeToLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
//        welcomeToLabel.font = UIFont(name: "SFProDisplay-Light", size: 32)
//        var paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 1.11

        // Line height: 42 pt
        // (identical to box height)

//        welcomeToLabel.textAlignment = .center
//        welcomeToLabel.attributedText = NSMutableAttributedString(string: "Welcome to", attributes: [NSAttributedString.Key.kern: -0.41, NSAttributedString.Key.paragraphStyle: paragraphStyle])

//        var parent = self.view!
//        parent.addSubview(welcomeToLabel )
//        welcomeToLabel.translatesAutoresizingMaskIntoConstraints = false
//        welcomeToLabel.heightAnchor.constraint(equalToConstant: 43).isActive = true
//        welcomeToLabel.topAnchor.constraint(equalTo: parent.topAnchor, constant: 146).isActive = true
//        welcomeToLabel.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 0).isActive = true
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
        if UserDefaults.standard.bool(forKey: "signed_in") {
            print("JUICE WRLD")
            transitionToHomeScreen()
        }
//        print("HELLO")
//        NotificationCenter.default.addObserver(self, selector: #selector(doSomething), name: UIApplication.willEnterForegroundNotification, object: nil)
//        let db = Firestore.firestore()
//        print("Signed In", UserDefaults.standard.bool(forKey: "signed_in"))
//        if UserDefaults.standard.bool(forKey: "Email Signed In") {
//            let link = UserDefaults.standard.string(forKey: "Link")
//            print("Link", link)
//            Auth.auth().signIn(withEmail: emailForLinkField.text!, link: link!) { (authResult, err) in
//                if err == nil && authResult != nil {
//                    if (Auth.auth().currentUser?.isEmailVerified)! {
//                        db.collection("users").document(authResult!.user.uid).setData(["display_name" : authResult!.user.displayName, "uid" : authResult!.user.uid]) { (error) in
//                            if error != nil {
//                                print("Name not captured")
//                            }
//                        }
//                        UserDefaults.standard.set(authResult!.user.uid, forKey: "uid")
//                        UserDefaults.standard.set(true, forKey: "signed_in")
//                        self.transitionToHomeScreen()
//
//                    }
//                }
//            }
//
//        }
//        if UserDefaults.standard.bool(forKey: "signed_in") {
//            transitionToHomeScreen()
//        }
    }
    
//    @objc func doSomething() {
//        print("Hello")
//    }
//    func isPasswordValid(_ password: String) -> Bool {
//        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$")
//        return passwordTest.evaluate(with: password)
//    }
//    func validateFields() -> String? {
//        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
//            return "Please enter all fields"
//        }
//        let cleanedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//        if !isPasswordValid(cleanedPassword!) {
//            return "Password has to be at least 8 characters long and contains 2 uppercase letters, 1 special case letter, 2 digits, and 3 lowercase letters."
//        }
//        return nil
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User Logged Out")
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if !result!.isCancelled {
//        print("Real Madrid", error!.localizedDescription)
            let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.tokenString)!)
            let db = Firestore.firestore()
            Auth.auth().signIn(with: credential) { (authResult, err) in
                
                if err == nil {
                    print("Firebase Log In Done Successful")
                    db.collection("users").document(authResult!.user.uid).updateData(["display_name" : authResult!.user.displayName, "uid" : authResult!.user.uid]) { (error) in
                        if error != nil {
                            print("Name not captured")
                        }
                    }
                    UserDefaults.standard.set(authResult!.user.uid, forKey: "uid")
                    UserDefaults.standard.set(true, forKey: "signed_in")
                    UserDefaults.standard.set("Facebook", forKey: "sign_in_method")
                    UserDefaults.standard.set(true, forKey: "should_query")
                    self.transitionToHomeScreen()
                } else {
                    print("Error", err!.localizedDescription)
                }
            }
        }
    }
//    @IBAction func didClickLogInButton(_ sender: Any) {
////        if let email = emailForLinkField.text {
////            let actionCodeSettings = ActionCodeSettings()
////            actionCodeSettings.handleCodeInApp = true
////            actionCodeSettings.url = URL.init(string: String(format: "https://introspection-a6d72.firebaseapp.com/?email=%@", email))
////            actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
////            Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { (err) in
////                if let e = err {
////                    print("Email not sent")
////                } else {
////                    print("Email Sent")
////                }
////            }
////        }
//        
//        
//        let error = validateFields()
//        if error != nil {
//            errorLabel.text = error!
//        } else {
//            let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            let password = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
//            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, error) in
//                if error != nil {
//                    self.errorLabel.text = error!.localizedDescription
//                }
//                UserDefaults.standard.set(self.emailTextField.text, forKey: "emailAddress")
//                self.transitionToHomeScreen()
//            }
//        }
//    }
//    
    @IBAction func didClickGoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
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
                    UserDefaults.standard.set("Google", forKey: "sign_in_method")
                    UserDefaults.standard.set(authResult.user.uid, forKey: "uid")
                    UserDefaults.standard.set(true, forKey: "signed_in")
                    UserDefaults.standard.set(true, forKey: "should_query")
    //                UserDefaults.standard.set(
                //                        if user.isEmailVerified {
                    UserDefaults.standard.set("\(first_name) \(last_name)", forKey: "Name")
//                    UserDefaults.standard.set("\(email)", forKey: "Email")
                    db.collection("users").document(authResult.user.uid).updateData(["first_name" : first_name, "last_name" : last_name, "uid" : authResult.user.uid]) { (error) in
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
    
    @IBAction func didClickFacebookLogin(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
          fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
          if (error == nil){
              let fbloginresult : LoginManagerLoginResult = result!
            // if user cancel the login
            if !result!.isCancelled {
            //        print("Real Madrid", error!.localizedDescription)
                        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.tokenString)!)
                        let db = Firestore.firestore()
                        Auth.auth().signIn(with: credential) { (authResult, err) in
                            if err == nil {
                                print("Firebase Log In Done Successful")
                                db.collection("users").document(authResult!.user.uid).updateData(["display_name" : authResult!.user.displayName, "uid" : authResult!.user.uid]) { (error) in
                                    if error != nil {
                                        print("Name not captured")
                                    }
                                }
                                UserDefaults.standard.set(authResult!.user.uid, forKey: "uid")
                                UserDefaults.standard.set(true, forKey: "signed_in")
                                UserDefaults.standard.set(true, forKey: "should_query")
                                self.transitionToHomeScreen()
                            } else {
                                print("Error", err!.localizedDescription)
                            }
                        }
                    }
//            if(fbloginresult.grantedPermissions.contains("email"))
//            {
//              self.getFBUserData()
//            }
          }
        }
    }
    

    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
          if (error == nil){
            //everything works print the user data
            print(result)
          }
        })
      }
    }


    
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
                print("UID!!!", result?.user.uid)
                UserDefaults.standard.set(result!.user.uid, forKey: "uid")
                UserDefaults.standard.set(true, forKey: "signed_in")
                UserDefaults.standard.set("Apple", forKey: "sign_in_method")
                db.collection("users").document(result!.user.uid).updateData(["first_name" : credential.fullName!.givenName, "last_name" : credential.fullName!.familyName, "uid" : result!.user.uid]) { (error) in
                    if error != nil {
                        print("Name not captured")
                    }
                }
                if err != nil {
                    print("Created User")
                }
                self.transitionToHomeScreen()
            }
        }
        
    }
}
