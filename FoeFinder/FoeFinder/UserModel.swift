/*
 1.
  Usernames:
  Matthew Clark (matkclar)
  Sasha Velet (svelet)
  Matthew Hammans (mmhamman)
 
 2. FoeFinder
 
 3. 04/28/2023
 */


// Profile and Message Class are also located in here

import UserNotifications
import Foundation
import UIKit
import CoreLocation

class UserModel {
    //               KEY[ KEY       : VALUES ] : VALUES
    //              [ currentUser : [user's matchs] ] : [Messages between them]
    //var conversations = [[Profile : [Profile]]        : [Message]]()
    var profiles: [Profile] = []
    var profileCurrentlyLoggedIn: Profile? = nil
    var loginInfo: Login = Login()
    
    init() {
        print("Model Initiliazed")
    }
    
    init(loginProfile : Profile) {
        profileCurrentlyLoggedIn = loginProfile
        
        profiles = loginInfo.profiles
        
        generatePossibleMatches()
    }
    
    func login(loginProfile : Profile) {
        // Logging in
        profileCurrentlyLoggedIn = loginProfile
        
        profiles = loginInfo.profiles
        
        generatePossibleMatches()
    }
    
    func save(){
        // save state of model, persistant storage?
        /*
        var found : Bool = false
        
        for profile in loginInfo.profiles {
            if profile == profileCurrentlyLoggedIn! {
                found = true
            }
        }
        if !found {
            loginInfo.profiles.append(profileCurrentlyLoggedIn!)
        }
         */
        /*
        var i: Int = 0
        for profile in loginInfo.profiles {
            if profile == profileCurrentlyLoggedIn {
                break;
            } else {
                i += 1
            }
        }
        
        loginInfo.profiles
        */
        // Save to Persistent Storage
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false)
            
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            
            let loginData = try encoder.encode(loginInfo)
            let loginFile = docsurl.appendingPathComponent("loginData.plist")
                        
            try loginData.write(to: loginFile, options: .atomic)
        }
        catch {
            print("Error Saving Model: \(error)")
        }
    }
    
    func generatePossibleMatches() {
        // Old Test Profiles
//        let match1: Profile = Profile(first: "Sasha", last: "Velet", day: 1, month: 12, year: 2001)
//        let match2: Profile = Profile(first: "Matthew", last: "Clark", day: 1, month: 2, year: 3001)
//        let match3: Profile = Profile(first: "Matthew", last: "Hammans", day: 25, month: 9, year: 2001)
        
        let stockFirstNames: [String] = ["Malcolm", "Serena", "Dante", "Raven", "Lucius", "Morgana", "Magnus", "Selene", "Draven", "Lilith", "Zephyr", "Circe", "Nero", "Azura", "Cassius", "Aurora", "Vesper", "Orion", "Eris", "Nyx"]

        let stockLastNames: [String] = ["Blackwood", "Noir", "Vex", "Ravenwood", "Grimm", "Nightrider", "Bloodstone", "Dread", "Nemesis", "Darkholme", "Raze", "Sable", "Scarlett", "Havoc", "Specter", "Stryker", "Vile", "Wraith", "Zephyr", "Shadow"]

        let stockLikes: [String] = ["Power", "Control", "Wealth", "Chaos", "Destruction", "Mayhem", "Revenge", "Dominance", "Betrayal", "Deception", "Annihilation", "Subjugation", "Terror", "Corruption", "Intimidation", "Darkness", "Armageddon", "Apocalypse", "Treachery", "Anarchy"]

        let stockDislikes: [String] = ["Justice", "Courage", "Honor", "Truth", "Compassion", "Valor", "Hope", "Integrity", "Freedom", "Peace", "Equality", "Heroism", "Protection", "Inspiration", "Strength", "Empathy", "Service", "Determination", "Resilience", "Teamwork"]
        
        var stockProfiles: [Profile] = []
        
        // Generate 20 Stock Profiles
        for _ in 0...20 {
            // Get Random Image
            let imageIndex: Int = Int.random(in: 1..<20)
            let imageName = "stock\(imageIndex)"
            guard let image = UIImage(named: imageName) else { return }
            
            // Get Random First Name
            let firstIndex: Int = Int.random(in: 0..<20)
            let firstName: String = stockFirstNames[firstIndex]
            
            // Get Random Last Name
            let lastIndex: Int = Int.random(in: 0..<20)
            let lastName: String = stockLastNames[lastIndex]
            
            // Get Random Date
            let randDay: Int = Int.random(in: 1..<30)
            let randMonth: Int = Int.random(in: 1..<12)
            let randYear: Int = Int.random(in: 1000..<3000)
            
            // Get Random Likes
            var randLikes: [String] = []
            let numLikes = Int.random(in: 1..<3)
            for _ in 0...numLikes {
                // Get Index of Random Like
                var likeIndex: Int = Int.random(in: 1..<20)
                
                // Ensure No Duplicates
                while (randLikes.contains(stockLikes[likeIndex])) {
                    likeIndex = Int.random(in: 1..<20)
                }
                
                // Append Chosen Like to Likes Array
                randLikes.append(stockLikes[likeIndex])
            }
            
            // Get Random Dislikes
            var randDislikes: [String] = []
            let numDislikes = Int.random(in: 1..<3)
            for _ in 0...numDislikes {
                // Get Index of Random Like
                var dislikeIndex: Int = Int.random(in: 1..<20)
                
                // Ensure No Duplicates
                while (randDislikes.contains(stockDislikes[dislikeIndex])) {
                    dislikeIndex = Int.random(in: 1..<20)
                }
                
                // Append Chosen Like to Likes Array
                randDislikes.append(stockDislikes[dislikeIndex])
            }
            
            // Construct Profile
            let addProfile: Profile = Profile(
                userImage: image, first : firstName, last : lastName,
                day : randDay, month : randMonth, year : randYear,
                likes: randLikes, dislikes: randDislikes)
                        
            // Append Profile to Stock Profile Array
            stockProfiles.append(addProfile)
        }
        
        // Set Possible Matches to Generated Profiles
        profileCurrentlyLoggedIn!.possibleMatches = stockProfiles
    }
}
       
    

// user profile
class Profile : Codable {
    
    // UIIMage is Not Codable by Default
    // userImage Starts as `Data` Type
    var userImage: Data
    
    var userName = ""
    let firstName: String
    let lastName: String
    var lastLogin: Date
    var birthday: Date
    var zodiacSign = "" // Zodiac Sign will match up users
    var likes : [String] // interests, hobbies, sign user is
    var dislikes : [String]
    
    var possibleMatches: [Profile] = []
    var matches: [Profile] = []
    var rejectedMatches: [Profile] = []
    
    var currentlyLoggedIn: Bool
    
    init(userImage: UIImage, first : String, last : String,
         day : Int, month : Int, year : Int,
         likes: [String], dislikes: [String]){
        
        // Set User Image as the PNG Data of Inputted Image
        do {
            try self.userImage = userImage.pngData()!
        }
        catch {
            print("Error Loading User Image \(error)")
        }
        
        // set birthday DATE variable
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let calendar = Calendar.current
        self.birthday = calendar.date(from: dateComponents)!
        
        // set name
        self.firstName = first
        self.lastName = last
        
        // init to empty at first
        self.likes = likes
        self.dislikes = dislikes
        self.matches = [Profile]()
        
        self.lastLogin = Date() // sets current date
        
        // set sign
        //self.zodiacSign = zodiacSign(for: month)
        // generate username
        //userName = generateRandomUsername(firstName: first, lastName: last)
        
        // false to keep it safe
        currentlyLoggedIn = false
    }
    
    func login(){
        currentlyLoggedIn = true
        
    }
    
    func logout(){
        currentlyLoggedIn = false
    }
    
    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.userName == rhs.userName
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(userName)
        }
    
    func generateRandomUsername(firstName: String, lastName: String) -> String {
        let randomNumber = Int.random(in: 100...999)
        let firstInitial = String(firstName.prefix(1))
        let lastInitial = String(lastName.prefix(1))
        return "\(firstInitial)\(lastInitial)\(randomNumber)"
    }
    
    // generates zodiac based on month
    private func zodiacSign(for month: Int) -> String {
            switch month {
            case 1:
                return "Capricorn"
            case 2:
                return "Aquarius"
            case 3:
                return "Pisces"
            case 4:
                return "Aries"
            case 5:
                return "Taurus"
            case 6:
                return "Gemini"
            case 7:
                return "Cancer"
            case 8:
                return "Leo"
            case 9:
                return "Virgo"
            case 10:
                return "Libra"
            case 11:
                return "Scorpio"
            case 12:
                return "Sagittarius"
            default:
                return "Invalid month"
            }
        }
}

class Login : NSObject, Codable {
    var userNames: [String] = []
    var passWords: [String] = []
    var profiles: [Profile] = []
}

class NotificationManager {

    // allows for the app to share this one instance of the Notification class
    static let shared = NotificationManager()
    // variable from which
    let center = UNUserNotificationCenter.current()
    // user coordinates
    var longitude : Double = 37.7749
    var latitude : Double = -122.4194

    private init() {}

    func requestAuthorization() {
         center.requestAuthorization(options: [.alert, .sound])
        { granted, error in
             if let e = error {
                 print("Error when requesting authorization: \(e)")
             }
         }
    }

    func checkAuthorization(){
        center.getNotificationSettings { [self] settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            if settings.alertSetting == .enabled {
                // Schedule an alert-only notification.
                // repeats every hour
                self.scheduleNotification(title: "Someone's nearby..", body: "Be careful, and stay armed.", interval: 3600, toRepeat : true)
                
            } else {
                // Schedule a notification with a badge and sound.
                // generate 3 random notifications that repeat after 10, 20, 40 seconds
                var intrTime = 10
                for i in 0..<3 {
                    self.scheduleNotification(title: self.warningPhrase(), body: self.ominousPhrase(), interval: TimeInterval(intrTime), toRepeat: false)
                    
                    // add 10+ seconds to next interval for notification
                    intrTime += 10
                    
                    // on last notification add user's coordinates
                    if i == 1 {
                        intrTime += 10
                        self.scheduleNotification(title: "I know where you are..", body: "Your coordinates: \(self.longitude) .. \(self.latitude).. better start running.", interval: TimeInterval(intrTime), toRepeat: false)
                    }
                }
            }
        }
    }
    
    private func ominousPhrase() -> String {
        let ominousPhrases = [
            "Someone is watching you.",
            "You are not alone.",
            "Beware of those around you.",
            "Someone is lurking in the shadows.",
            "You are being followed.",
            "Watch your back.",
            "The danger is close.",
            "You are being watched."
        ]
        
        // solely for the purpose of generating phrases
        let randomIndex = Int.random(in: 0..<ominousPhrases.count)
        return ominousPhrases[randomIndex]
    }
    
    private func warningPhrase() -> String {
        let warningPhrases = [
            "Watch out!",
            "Heads up!",
            "Look out!",
            "Stay alert!",
            "Mind yourself!",
            "Stay safe!",
            "Be on guard!",
            "Stay vigilant!",
            "Be mindful!",
            "Stay cautious!",
            "Pay attention!",
            "Stay focused!",
            "Be wary!",
            "Be on the lookout!",
            "Stay on high alert!"
        ]
        
        // solely for the purpose of generating phrases
        let randomIndex = Int.random(in: 0..<warningPhrases.count)
        return warningPhrases[randomIndex]
    }
    
    
    private func scheduleNotification(title: String, body: String, interval: TimeInterval, toRepeat : Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.defaultCritical
        
        if toRepeat {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                // Handle the result of the notification request
                if let e = error {
                    print("Error when scheduling repeating notifications: \(e)")
                }
            }
        } else {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                // Handle the result of the notification request
                if let e = error {
                    print("Error when scheduling non-repeating notifications: \(e)")
                }
            }
        }
        
    }
}
