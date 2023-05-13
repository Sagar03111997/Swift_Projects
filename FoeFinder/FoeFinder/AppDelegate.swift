/*
 1.
  Usernames:
  Matthew Clark (matkclar)
  Sasha Velet (svelet)
  Matthew Hammans (mmhamman)
 
 2. FoeFinder
 
 3. 04/28/2023
 */


import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // create new model
    var userModel = UserModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //for testing
        let tempImage = UIImage(named: "stock1")!
        /*
        let currentlyLoggedIn: Profile = Profile(userImage: tempImage,
                                                 first: "Some", last: "Dude",
                                                 day: 1, month: 1, year: 3000,
                                                 likes: [], dislikes: [])
        
        
        
        userModel.loginInfo.profiles.append(currentlyLoggedIn)
        userModel.profiles.append(currentlyLoggedIn)
        
        userModel.profileCurrentlyLoggedIn = currentlyLoggedIn
         
        userModel.generatePossibleMatches()
         */
        print("Logged in")
        
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let loginFile = docsurl.appendingPathComponent("loginData.plist")
            
            let loginData = try Data(contentsOf: loginFile)
            
            let users = try PropertyListDecoder().decode(Login.self, from: loginData)
            
            userModel.loginInfo = users
            
            print(docsurl)
                        
            /*
            let temp : UserModel = UserModel(loginProfile: userModel.loginInfo.profiles[0])
            userModel = temp
            
            userModel.loginInfo.profiles.append(currentlyLoggedIn)
            userModel.profiles.append(currentlyLoggedIn)
             */
            print("Login Successful")
        }
        catch {
            print("Error Reading Model: \(error)")
        }
         
        
        //  ========== ========== =NotificationManager class is in UserModel.swift= ========== ========== 
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.checkAuthorization()
        
        return true
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

