//
//  AppDelegate.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/10/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do {
            _ = try Realm()
         
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        
        // shows document path for running app
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }


    
}



