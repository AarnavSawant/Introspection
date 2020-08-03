//
//  AppDelegate.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/2/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    var window: UIWindow?
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self
//        Analytics.logEvent("This is a test", parameters: [
//        "Test1": "tester",
//        "Test2": "tester"
//        ])
//        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        return true
    }

    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
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
                
                
            // Post notification after user successfully sign in
//            NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
        }

//        let userId = user.userID                  // For client-side use only!
//         let idToken = user.authentication.idToken // Safe to send to the server
//         let fullName = user.profile.name
//        print("Jimmy", fullName)
//         let givenName = user.profile.givenName
//         let familyName = user.profile.familyName
//         let email = user.profile.email
      // ...
    }
    }

    func transitionToHomeScreen() {
        let vc = self.window?.rootViewController?.storyboard?.instantiateViewController(identifier: "tabbar") as? MainTabBarController
        self.window?.rootViewController = vc
//        view.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
//        self.saveContext()
    }
    // MARK: - Core Data stack
//    lazy var persistentContainer: NSPersistentContainer = {
//    let container = NSPersistentContainer(name: "DataModel")
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//    if let error = error as NSError? {
//    fatalError("Unresolved error \(error), \(error.userInfo)")
//    }
//    })
//    return container
//    }()
    // MARK: - Core Data Saving support
//    func saveContext () {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//    do {
//    try context.save()
//    } catch {
    // Replace this implementation with code to handle the error appropriately.
    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//    let nserror = error as NSError
//    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//    }

//}
//}
}

