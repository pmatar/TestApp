//
//  AppDelegate.swift
//  TestApp
//
//  Created by Paul Matar on 27/05/2022.

// app ID: ca-app-pub-6115208696875604~2245959543
// unit ID: ca-app-pub-6115208696875604/5118453320
// test ID: ca-app-pub-3940256099942544/2934735716

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import Firebase
import FirebaseMessaging
import UserNotifications
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            guard success, error == nil else {
                print(error?.localizedDescription ?? "No localized error info")
                return
            }
            
            print("Success in APNS registry")
        }
        
        application.registerForRemoteNotifications()
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, error in
            guard let token = token, error == nil else {
                print(error?.localizedDescription ?? "No localized error info")
                return
            }
            print("Token: \(token)")
        }
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


}

