//
//  AppDelegate.swift
//  BulletJournal
//
//  Created by Megan Pitts on 4/10/23.
//
//Team Members:
//Saiesha Sharma: saieshar@iu.edu
//Megan Pitts: megpitts@iu.edu
//App Name: Bullet Journal
//Submission Date: 4/25/23

import UIKit
import EventKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let theModel : JournalEntriesModel = JournalEntriesModel()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //-------Reminders Setup--------------
        //citation: https://developer.apple.com/documentation/eventkit
        // Initialize the store for getting reminders and calendar events
        let store = EKEventStore()

        // Request access to reminders.
        store.requestAccess(to: .reminder) { (granted, error) in
            //if there was an error, print it
            if let error = error {
                print("EKEventStore request access completed with error: \(error.localizedDescription)")
                return
            }
            
            //if we get access, start pulling reminders and saving them to the model
            if granted{
                let predicate: NSPredicate? = store.predicateForReminders(in: nil)
                if let aPredicate = predicate {
                    store.fetchReminders(matching: aPredicate, completion: {(_ reminders: [Any]?) -> Void in
                        for reminder: EKReminder? in reminders as? [EKReminder?] ?? [EKReminder?]() {
                            if !reminder!.isCompleted{
                                //for each reminder that is not completed, add it to the model
                                self.theModel.addToReminders(reminder: reminder)
                            }
                        }
                        //create our notification
                        let notification:Notification = .init(name: .EditingReminders)
                        //send out our notification when the data is updated
                        NotificationCenter.default.post(notification)
                    })
                }
            }
        }
        
        
        //this gets all entry information excluding photos from persistent storage
        do{
            //set up our .plist file
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let arrfile2 = docsurl.appendingPathComponent("BulletJournalPlist.plist")
            print("retrieving saved plist array")
            //getting the contents of the file and decoding them
            let arraydata = try Data(contentsOf: arrfile2)
            let arr = try PropertyListDecoder().decode([Entry].self, from:arraydata)
            print(arr)
            //add the array of data to the model
            self.theModel.readToModel(entryData: arr)
        }catch{
            print(error)
        }
        
        //get photos from persistent storage
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            //gets all photos from doc directory
            let photoFiles = try fm.contentsOfDirectory(atPath: docsurl.path).filter { $0.hasPrefix("photo-") }
            
            for photoFile in photoFiles {
                let photoUrl = docsurl.appendingPathComponent(photoFile)
                if let data = try? Data(contentsOf: photoUrl), let image = UIImage(data: data) {
                    //send to model
                    self.theModel.readToPhotos(photo: image)
                }
            }
        } catch {
            print(error)
        }
        
        //------------Notifications Setup-----------------
        //citation: https://developer.apple.com/documentation/usernotifications
        //get permission to send notifications
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error here.
                print("we had an error boo")
                print(error)
            }
        }
        
        //check the user settings
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }

            //if they gave permission, set up the notification
            if settings.alertSetting == .enabled {
                //this is the content of our reminder
                let content = UNMutableNotificationContent()
                content.title = "Add Your Entry for the Day"
                content.body = "Every Day at 8pm"
                
                // Configure the recurring date.
                var dateComponents = DateComponents()

                //actual time to use for user
                dateComponents.hour = 20   // at 8pm
                dateComponents.minute = 0
                
                //test times
//                dateComponents.hour = 15 //24 hour time
//                dateComponents.minute = 10
                   
                // Create the trigger as a repeating event that goes off every day.
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                // Create the request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                            content: content, trigger: trigger)

                // Schedule the request with the system.
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request) { (error) in
                   if error != nil {
                      // Handle any errors.
                       print("notification error")
                   }
                }
            } else {
                // Schedule a notification with a badge and sound.
                //dont need this
            }
        }
        
        //calls the function below which makes the notifications delegate to be self, or the AppDelegate.
        configureUserNotifications()
        return true
    }
    
    private func configureUserNotifications() {
      UNUserNotificationCenter.current().delegate = self
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

// MARK: - UNUserNotificationCenterDelegate
//citation: https://developer.apple.com/documentation/usernotifications
//allows the notification to present when the app is in the foreground
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,
    withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.banner)
  }
}

//MARK: Create our notification name
extension Notification.Name{
//Sent when an EditingViewController modifies data in the Model.
    static let EditingReminders = Notification.Name.init("EditingReminders")
}

