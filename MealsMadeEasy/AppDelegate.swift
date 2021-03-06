//
//  AppDelegate.swift
//  MealsMadeEasy
//
//  Created by Tai Tran on 1/17/18.
//  Copyright © 2018 Tai Tran. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    var mainStoryBoard: UIStoryboard?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let isUserLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (isUserLoggedIn) {
            let homePage = mainStoryBoard!.instantiateViewController(withIdentifier: "TabBar") as! TabBarViewController
            self.window?.rootViewController = homePage
        } else {
            let loginPage = mainStoryBoard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.window?.rootViewController = loginPage
        }
        // Override point for customization after application launch.
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Login Error")
            return
        }
        print("User Signed Into Google")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        print("\(credential)")
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("error")
                return
            }
            print("User Signed Into Firebase")
            // User is signed in
            UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            
            let onboarding = self.mainStoryBoard!.instantiateViewController(withIdentifier: "Useronboarding") as! UseronboardingController
            self.window?.rootViewController?.present(onboarding, animated: true, completion: nil)
        }
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

