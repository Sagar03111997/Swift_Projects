//
//  JournalEntries.swift
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
import Foundation
import EventKit

class JournalEntriesModel{
    
    var entries: [Entry] = []
    var photos: [UIImage] = []
    var reminders: [String] = []
    
    init(){
        
    }
    
    func addEntry(e: Entry) -> Void{
        
        //save to all our entries
        self.entries.append(e)
        
        //persistent storage for an entry excluding photos
        do {
            let fm = FileManager.default
            let docsurl = try fm.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print("serializing entries using property list encoder")
            //encode the entries
            let test = e
            let testData = try PropertyListEncoder().encode(test)
            let testFile = docsurl.appendingPathComponent("test.txt")
            
            //write the entries to our file
            print("writing serialized friend to file")
            try testData.write(to: testFile, options: .atomic)
            
            let bulletJournalPlist = self.entries
            print("printing entries: ")
            print(bulletJournalPlist)
            let arrfile2 = docsurl.appendingPathComponent("BulletJournalPlist.plist")
            let plister = PropertyListEncoder()
            plister.outputFormat = .xml // just so we can read it
            print("attempting successfully to write an array by encoding to plist first")
            try plister.encode(bulletJournalPlist).write(to: arrfile2, options: .atomic)
            let s = try String.init(contentsOf: arrfile2)
            print(s) // show it as XML
        } catch {
            print(error)
        }
        
    }
    
    func addToPhotos(photo: UIImage){
        //called when photos are being saved and added to persistent storage
        
        //making a random name for the file
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        let dateString = formatter.string(from: Date())
        let fileName = "photo-\(dateString).jpg"
        
        // saving in documents on the app
        if let data = photo.jpegData(compressionQuality: 1.0),
           let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
            do {
                try data.write(to: url)
            } catch {
                print("Error: \(error)")
            }
            
            //save the photo to our model storage
            self.photos.insert(photo, at: 0)
        }
    }
    
    func addToReminders(reminder: EKReminder?) -> Void{
        self.reminders.append(reminder!.title)
    }
    
    func getReminders() -> [String]{
        return self.reminders
    }
    
    func getPhotos() -> [UIImage]{
        return self.photos
    }
    
    func getJournalEntries() -> [Entry]{
        return self.entries
    }
    
    //this relates to persistent storage and how the appdelegate reads it all in
    func readToModel(entryData: [Entry]){
        self.entries = entryData
    }
    
    //reads photos to model once app loads
    func readToPhotos(photo: UIImage) {
        self.photos.insert(photo, at: 0)
    }
}
    
    class Entry: NSObject, Codable{
        var mood: String
        var notes: String
        var recipe: String
        var date = Date()
        
        override var description : String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YY/MM/dd"
            return "Entry from " + dateFormatter.string(from: self.date) + "\n"
        }
        
        init(m: String, n: String, r: String, d: Date){
            self.mood = m
            self.notes = n
            self.recipe = r
            self.date = d
        }
        
        func getMood() -> String{
            return self.mood
        }
        
        func getNotes() -> String{
            return self.notes
        }
        
        func getRecipe() -> String{
            return self.recipe
        }
        
        func getDate() -> Date{
            return self.date
        }
        
    }
    

