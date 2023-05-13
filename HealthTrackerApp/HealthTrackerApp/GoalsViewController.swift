//Health Tracker
//Deecon Precht
    //dgprecht@iu.edu
//Nicholas Van Burk
    //ndvanbur@iu.edu
//28 APR 2023

import UIKit
import UserNotifications

class GoalsViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var delegate: AppDelegate?
    var model: User?
        
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBAction func setGoalButton(_ sender: Any) {
        let content = UNMutableNotificationContent()
        let center = UNUserNotificationCenter.current()
        
        // setting up the notification
        content.title = "New Goal Set!"
        content.subtitle = "\(textField.text ?? "")"
        content.body = "We expect you to reach your goal by \(datePicker.date.formatted())"
        content.sound = UNNotificationSound.default
        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 7, repeats: false)
        let req = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trig)
        center.add(req)
        // add/store goal and date to arrays
        if let mdl = model { mdl.addGoal(title: textField.text ?? "" , date: datePicker.date) }
        // resetting text for next input
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.delegate?.model
    }
    
}
