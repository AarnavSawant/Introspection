//
//  AppDelegate.swift
//  MentalHealthAI
//
//  Created by Parikshat Sawant on 7/2/20.
//  Copyright © 2020 Sawant,Inc. All rights reserved.
//
import UserNotifications
import UIKit
import Firebase
import CoreData
import FirebaseFirestore
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    var window: UIWindow?
    

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, err) in
            print("Permission Granted: ", granted)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        // Override point for customization after application launch.
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }

   
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:])
      -> Bool {
        print("URL", url)
        return ApplicationDelegate.shared.application(
            application,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        ) || GIDSignIn.sharedInstance().handle(url)
    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//            print("URL", url)
//            return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) ||
//            GIDSignIn.sharedInstance().handle(url)
//    }
    
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
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping([Any]?)-> Void) -> Bool {
//        return userActivity.webpageURL.flatMap(handlePasswordlessSignIn)!
//    }
//    func handlePasswordlessSignIn(withURL url: URL) -> Bool{
//        let link = url.absoluteString
//        print("Link", link)
//        if Auth.auth().isSignIn(withEmailLink: link) {
//            UserDefaults.standard.set(true, forKey: "Email Signed In")
//            UserDefaults.standard.set(link, forKey: "Link")
//            return true
//        }
//        return false
//    }
    
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
