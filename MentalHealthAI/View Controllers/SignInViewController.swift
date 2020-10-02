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
class SignInViewController: UIViewController, GIDSignInDelegate, ASAuthorizationControllerPresentationContextProviding  {
    
    
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

    override func viewDidLoad() {
        Analytics.logEvent("entered_SignIn_Screen", parameters: nil)
//        UserDefaults.standard.set(nil, forKey: "NotificationsEnabledInApp")
//        
//        UserDefaults.standard.set(nil, forKey: "NotificationTime")
        appleButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        appleButton.backgroundColor = .white

        appleButton.layer.cornerRadius = 11.08
        appleButton.layer.borderWidth = 2
        appleButton.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor

        var parent = self.view!

        introspectionView.frame = CGRect(x: 0, y: 0, width: 228.67, height: 36.67)
        introspectionView.backgroundColor = .white


//        var parent = self.view!
//        parent.addSubview(view)
        introspectionView.translatesAutoresizingMaskIntoConstraints = false

        
        haveFunLabel.frame = CGRect(x: 0, y: 0, width: 286, height: 64)
        haveFunLabel.backgroundColor = .white

        haveFunLabel.alpha = 0.6
        haveFunLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)
        haveFunLabel.font = UIFont(name: "SFProText-Medium", size: 18)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 2.96


        appleButton.topAnchor.constraint(equalTo: parent.topAnchor, constant: 292).isActive = true
//        var view = UILabel()
        googleButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        googleButton.backgroundColor = .white
//        signInButton.style = GIDSignInButtonStyle.init(rawValue: 1)!
        googleButton.layer.backgroundColor = UIColor(red: 0.259, green: 0.522, blue: 0.957, alpha: 1).cgColor
        googleButton.layer.cornerRadius = 11.08
        googleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        googleButton.translatesAutoresizingMaskIntoConstraints = false



        print("SIGNED IN SignIN", UserDefaults.standard.bool(forKey: "signed_in"))
        logInImageView.frame = CGRect(x: 0, y: 0, width: 488, height: 292.66)
        logInImageView.backgroundColor = .white

        logInImageView.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor


        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        facebookButton.frame = CGRect(x: 0, y: 0, width: 310, height: 54)
        facebookButton.backgroundColor = .white

        facebookButton.layer.backgroundColor = UIColor(red: 0.235, green: 0.353, blue: 0.604, alpha: 1).cgColor
        facebookButton.layer.cornerRadius = 11.08


        facebookButton.translatesAutoresizingMaskIntoConstraints = false

        
        GIDSignIn.sharedInstance()?.delegate = self
                GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        welcomeToLabel.frame = CGRect(x: 0, y: 0, width: 152, height: 43)
        welcomeToLabel.backgroundColor = .white

        welcomeToLabel.textColor = UIColor(red: 0.008, green: 0.02, blue: 0.039, alpha: 1)

    }
    
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
            print("TRANSITIONING TO HOME SCREEN")
            transitionToHomeScreen()
        }

    }
    

    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User Logged Out")
        
    }
    


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
//                    UserDefaults.standard.set(authResult.user.uid, forKey: "uid")
                    UserDefaults.standard.set(true, forKey: "signed_in")
                    UserDefaults.standard.set(true, forKey: "should_query")
    //                UserDefaults.standard.set(
                //                        if user.isEmailVerified {
                    if (UserDefaults.standard.string(forKey: "NotificationTime") == nil) {
//                        if (UserDefaults.standard.string(forKey: "NotificationTime") != "NOT ENABLED") {
                            self.setDefaultNotification()
//                        }
                    }
//                    UserDefaults.standard.set("\(email)", forKey: "Email")
                    db.collection("users").document(authResult.user.uid).getDocument { (document, err) in
                        if !document!.exists {
                            db.collection("users").document(authResult.user.uid).setData(["first_name" : first_name, "last_name" : last_name, "uid" : authResult.user.uid]) { (error) in
                                if error != nil {
                                    print("Name not captured")
                                }
                            }
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
                        let credential = FacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.tokenString)!)
                        let db = Firestore.firestore()
                        Auth.auth().signIn(with: credential) { (authResult, err) in
                            if err == nil {
                                UserDefaults.standard.set("Facebook", forKey: "sign_in_method")
                                print("Firebase Log In Done Successful")
                                db.collection("users").document(authResult!.user.uid).getDocument { (document, err) in
                                    if !document!.exists {
                                        db.collection("users").document(authResult!.user.uid).setData(["display_name" : authResult!.user.displayName, "uid" : authResult!.user.uid]) { (error) in
                                            if error != nil {
                                                print("Name not captured")
                                            }
                                        }
                                    }
                                }
                                UserDefaults.standard.set(true, forKey: "signed_in")
                                if (UserDefaults.standard.string(forKey: "NotificationTime") == nil) {
//                                    if (UserDefaults.standard.string(forKey: "NotificationTime") != "NOT ENABLED") {
                                        self.setDefaultNotification()
//                                    }
                                }
                                UserDefaults.standard.set(true, forKey: "should_query")
                                self.transitionToHomeScreen()
                            } else {
                                print("Error", err!.localizedDescription)
                            }
                        }
                    }
          }
        }
    }
    func setDefaultNotification() {
                    print("Notifications Registered")
                        var content = UNMutableNotificationContent()
                                    content.title = "It's Time to Introspect!"
                                    content.body = "Take a step back from your day and reflect!"
                                    var dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "h:mm a"
                                    var components = DateComponents()
                                    let date = dateFormatter.date(from: "9:50 PM")!
                                    UserDefaults.standard.set("9:50 PM", forKey: "NotificationTime")
                                    let calendar = Calendar.current.dateComponents([.hour, .minute], from: date)
                                    let center = UNUserNotificationCenter.current()
                                    components.hour = calendar.hour
                                    components.minute = calendar.minute
                        //            UNNotificationRequest
                                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true).self
                                    let request = UNNotificationRequest(identifier: "IntrospectionNotification", content: content, trigger: trigger)
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                UserDefaults.standard.set(true, forKey: "NotificationsEnabledInApp")
            } else {
                UserDefaults.standard.set(false, forKey: "NotificationsEnabledInApp")
            }
        }
                                center.removeAllPendingNotificationRequests()
                                    center.add(request) { (err) in
                                        if err == nil {
                                            print("Notification Created")
                                        }
                                    }
//            }
    //        sender.isOn = false
         
            
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
        print("Requesting Authorization")
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
                UserDefaults.standard.set(true, forKey: "signed_in")
                UserDefaults.standard.set("Apple", forKey: "sign_in_method")
                print("Notification Time", UserDefaults.standard.string(forKey: "NotificationTime"))
                if (UserDefaults.standard.string(forKey: "NotificationTime") == nil) {
                        print("Inside the Notification Time if condition")
//                    if (UserDefaults.standard.string(forKey: "NotificationTime") != "NOT ENABLED") {
                        self.setDefaultNotification()
//                    }
                }
                db.collection("users").document(result!.user.uid).setData(["first_name" : credential.fullName!.givenName, "last_name" : credential.fullName!.familyName, "uid" : result!.user.uid]) { (error) in
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
