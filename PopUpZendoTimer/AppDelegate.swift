//
//  AppDelegate.swift
//  PopUpZendoTimer
//
//  Created by Joseph Hall on 8/26/19.
//  Copyright © 2019 Joseph Hall. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseStorage
import OneSignal




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("local notification permissions granted")
            } else {
                print("local notification permissions denied")
            }
        }
        
        FirebaseApp.configure()
        let storage = Storage.storage()
        
        
        
        UserDefaults.standard.register(defaults: [
           
            "mode": true,
            "bell": true,
            //"sound": "mediumKesu",
            "bellSound": "small-bell",
            "ext": "aiff",
            "bellImage": "small-bell",
            "countdownNumber": 4,
            "startNumber": 3,
            "endNumber": 1,
            "hanTime": Date(),
            "hanMute": true,
            "kinhinSlide": 10
            
            
            ])
        
        //Remove this method to stop OneSignal Debugging
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)

        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
          appId: "75931b8a-9a75-4591-b18b-d64273e1f0f9",
          handleNotificationAction: nil,
          settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        //END OneSignal initializataion code
        
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
         
             let userID = status.subscriptionStatus.userId
             print("userID = \(String(describing: userID))")
             let pushToken = status.subscriptionStatus.pushToken
             print("pushToken = \(String(describing: pushToken))")
         
         
         //OneSignal.setEmail("example@domain.com");
         
            if pushToken != nil {
                 if let playerId = userID {

                    OneSignalService.instance.uploadPlayerId(withPlayerId: playerId, forUserId: Auth.auth().currentUser!.uid, forUID: (Auth.auth().currentUser?.uid)!, withKey: nil, sendComplete: { (isComplete) in
                         if isComplete {
                             print("Completed playerID Upload")
                         } else {
                             print("There was an error!")
                         }
                     })
                 }
             }
         center.requestAuthorization(options: [.alert, .sound]) { granted, error in
         }
        
        return true
    }
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



extension AppDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // instantiate the view controller from storyboard
        if  let HanVC = storyboard.instantiateViewController(withIdentifier: "HanVC") as? HanVC {

            // set the view controller as root
            self.window?.rootViewController = HanVC
        }
        
        // tell the app that we have finished processing the user’s action / response
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")

        completionHandler([.sound, .alert])
    }
    
    
    

}

