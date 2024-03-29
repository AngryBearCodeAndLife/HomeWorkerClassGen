//
//  AppDelegate.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func goToView(_ destination: UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = destination
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Need to figure out if they have launched the app before.
            //if they have, they should try to be logged in,
                //If that succeeds, bring them to the home page
                //If it does not succeed, they should be prompted to log in, stating their accounthas reason for us to question their identity
            //Ifthey have not, they should be brought to the onboarding procedure
        
        
        //#LoveSudoCode ***********************
        
        FirebaseApp.configure()
        
        if DataStorage.AutoLoggin.isEnabled() {
            AuthActions.openApp { success in
                if success {
                    self.goToView(WorkView())
                } else {
                    self.goToView(SignInController())
                }
            }
        } else {
            self.goToView(SignInController())
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
        
        AuthActions.closeApp()
    }


}

