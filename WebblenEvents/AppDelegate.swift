//
//  AppDelegate.swift
//  WebblenEvents
//
//  Created by Mukai Selekwa on 12/10/16.
//  Copyright © 2016 Mukai Selekwa. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = .default
        
        //FB Authentication
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Google Authentication
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        //Create notification center
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in})
        }
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyDG-kmaqXsZRJwMFDyE--2LAi1Bsnw803U")
        GMSPlacesClient.provideAPIKey("AIzaSyDG-kmaqXsZRJwMFDyE--2LAi1Bsnw803U")

        
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation] )
        
        GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
        
        // Add any custom logic here.
        return handled;
        

        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("Registrations succeeded! Token: ", token )
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("Registration Failed")
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
        // Saves changes in the application's managed object context before the application terminates.
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notificaiton: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void){
        
        //custom code to handle push while app in foreground
        
        let dict = notificaiton.request.content.userInfo["aps"] as! NSDictionary
        let d : [String : Any] = dict["alert"] as! [String : Any]
        let body : String = d["body"] as! String
        let title : String = d["title"] as! String
        self.showAlertAppDelegate(title: title, message: body, buttonTitle: "ok", window: self.window!)
        
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // If..
        print("Handle push from background or closed\(response.notification.request.content.userInfo)")
    }
    
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        window.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

