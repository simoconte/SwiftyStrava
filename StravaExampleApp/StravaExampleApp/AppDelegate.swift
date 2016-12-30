//
//  AppDelegate.swift
//  StravaExampleApp
//
//  Created by Oleksandr Glagoliev on 27/12/2016.
//  Copyright © 2016 Oleksandr Glagoliev. All rights reserved.
//

import UIKit
import Strava

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        // Configure Strava Client
        let clientId: Int64 = 12886 // Client id provided during app registration
        let clientSecret: String = "f751142336db9b849591af85c314b1d12f7f5639" // Client secret provided during app registration
        let callbackURL: String = "facewind://io.limlab.facewind" // URL from "URL Types"
        StravaClient.instance.configure(clientId: clientId, clientSecret: clientSecret, callbackURL: callbackURL)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        do {
            let credentials = try StravaClient.instance.extractAccessCredentials(from: url)
            print(credentials)
            StravaClient.instance.authorize(credentials: credentials, completion: { auth in
                
            })
        } catch OAuthError.urlMalformed {
            print("Error -> Not authorized! ULR malformed")
        } catch OAuthError.notAuthorized(reason: let reason) {
            print("Error -> Not authorized! Reason: \(reason)")
        } catch {
            print("Error -> OAuth error!")
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

