//
//  NotificationHelper.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import Foundation
import UserNotifications

class NotificationHelper: NSObject {
    
    let categoryIdentifier = "cashmap"
    
    var clearAllCategories = false
    var clearAllNotifications = false
    
    func bootstrapNotifications() {
        let center = UNUserNotificationCenter.current()
        
        if clearAllCategories {
            center.setNotificationCategories([])
        }
        
        if clearAllNotifications {
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
        }
        
        self.checkAuthorization()
    }
    
    private func checkAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {
            settings in
            
            _ = ["not determined", "denied", "authorized", "provisional"]
            
            switch settings.authorizationStatus {
            case .notDetermined:
                self.doAuthorization()
            case .denied:
                break
            case .authorized, .provisional, .ephemeral:
                self.checkCategories()
            @unknown default:
                fatalError()
            }
        }
    }
    
    var provisional = false
    private func doAuthorization() {
        let center = UNUserNotificationCenter.current()
        var opts: UNAuthorizationOptions = [.alert, .sound, .badge, .providesAppNotificationSettings]
        if provisional {
            opts.insert(.provisional)
        }
        
        center.requestAuthorization(options: opts) { ok, err in
            if let err = err {
                print(err)
                return
            }
            if ok {
                print("we got authorization")
                self.checkCategories()
            } else {
                print("user refused authorization")
            }
        }
    }
    
    private func checkCategories() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationCategories { cats in
            var cats = cats
            
            let newCat = self.configureCategory()
            cats.formUnion(newCat)
            center.setNotificationCategories(cats)
        }
    }
    
    var customDismiss = true
    private func configureCategory() -> [UNNotificationCategory] {        
        let actions: [UNNotificationAction] = []
        
        let opts: UNNotificationCategoryOptions = customDismiss ? [.customDismissAction] : []
        let summary = "%u more reminders from %@"
        
        let cat = UNNotificationCategory(identifier: self.categoryIdentifier, actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: nil, categorySummaryFormat: summary, options: opts)
        
        return [cat]
    }
    
    func createNotification(_ title: String, _ body: String) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.userInfo["scheduled"] = Date()
        
        content.categoryIdentifier = self.categoryIdentifier
        
        var useUUID: Bool { return true }
        let uuid = UUID()
        
        let id = "cashMap" + (useUUID ? uuid.uuidString : "")
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(req)
    }
}

extension NotificationHelper : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var ok: Bool { true }
        if ok {
            completionHandler([.sound, .banner])
        } else {
            completionHandler([])
        }
    }
}
