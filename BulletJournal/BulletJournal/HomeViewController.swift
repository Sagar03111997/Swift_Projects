//
//  HomeViewController.swift
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
import SwiftUI
import EventKit


class HomeViewController: UIViewController, UITextViewDelegate{
    
    //the model
    var theAppDelegate: AppDelegate?
    var journal: JournalEntriesModel = JournalEntriesModel()

    //our labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var remindersTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the model
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        if let journalModel = self.theAppDelegate?.theModel {
            self.journal = journalModel
        } else {
            print("Home Model Fail")
        }
        
        //check if data from the appdelegate has been updated
        //if it has, call the function below and update the reminders box
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .EditingReminders, object: nil)
    
    }
    
    @objc func reloadData(){
        /*reload the data we show to the user here*/
        //print("Reloading User Data")
        //-----------reminder setup-----------------
        let reminders = self.journal.getReminders()
        var reminderText = ""
        for item in reminders{
            reminderText = reminderText + "-" +  item + "\n"
        }
        DispatchQueue.main.async {
            self.remindersTextView.text = reminderText
        }
        
    }
    
    //turn off the notication from the AppDelegate, so it isn't constantly running
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //updating the date label to the current, formatted date
        self.dateLabel.text = Date().formatted(date: .abbreviated, time: .omitted)
        
        //set up previous mood and recipe recommendation
        let journal = self.journal.getJournalEntries()
        let jSize = journal.count
        
        //-----------mood setup-----------------
        //if there are any entries in the journal
        if(jSize > 0){
            //if we have at least two entries...
            if(jSize > 1){
                //and the last entry is from today
                if(Calendar.current.isDateInToday(journal[jSize - 1].getDate())){
                    //set the mood to be the second to last entry
                    self.moodLabel.text = journal[jSize - 2].getMood()
                }else{//if the last entry is from yesterday
                    //set the mood to be the last entry
                    self.moodLabel.text = journal[jSize - 1].getMood()
                }
            }
            //if there's only one entry and its from yesterday...
            if(jSize == 1){
                if(Calendar.current.isDateInYesterday(journal[0].getDate())){
                    //set the mood to be from the one entry
                    self.moodLabel.text = journal[0].getMood()
                }else{ //else the one entry is from today or a day that was further back than yesterday
                    self.moodLabel.text = "Your mood for the previous day will be here."
                }
            }
        }else{
            //if there are zero entries
            self.moodLabel.text = "Your mood for the previous day will be here."
        }
        
        //if someone didn't enter a mood with their entry...
        if self.moodLabel.text == ""{
            self.moodLabel.text = "Your mood for the previous day will be here"
        }
        
        //-----------recipe setup-----------------
        //if there is more than one entry present
        if(jSize == 1){ //if there is only one entry, use that recipe
            self.recipeLabel.text = journal[0].getRecipe()
        }else if(jSize > 1){
            //get a random entry and its recpie to recommend
            let randomInt = Int.random(in: 0..<jSize)
            self.recipeLabel.text = journal[randomInt].getRecipe()
        }else{//if there are no entries
            self.recipeLabel.text = "Enter a recipe to see recommendations"
        }
        
        //if someone didn't enter a recipe with their entry...
        if self.recipeLabel.text == ""{
            self.recipeLabel.text = "Recipes will appear here"
        }
        
        //update the reminders label
        reloadData()
        
        // Do any additional setup after loading the view.
    }
    
   
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
