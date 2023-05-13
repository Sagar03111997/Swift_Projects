//
//  AppDelegate.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let transactionsModel = TransactionsModel()
    let notifHelper = NotificationHelper()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Perform data loading
        self.transactionsModel.loadTransactions()
        
        
        //  ---------- CONSTRUCTINON ZONE
        //saving the model to UserDefaults for use in the Widgets
        
//        do {
//            let defaults = UserDefaults.standard
//            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: transactionsModel, requiringSecureCoding: true)
//            defaults.set(encodedData, forKey: "myTransactionModel")
//        }
//        catch{
//            print("error trying to archive data into UserDefaults")
//        }
        
        
        
        

        //  CONSTRUCTINON ZONE ----------
        
        
        
        // Set up user notifications delegate and helper
        let center = UNUserNotificationCenter.current()
        center.delegate = self.notifHelper
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

