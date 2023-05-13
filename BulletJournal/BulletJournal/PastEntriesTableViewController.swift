//
//  PastEntriesTableViewController.swift
//  BulletJournal
//
//  Created by Megan Pitts on 4/11/23.
//
//Team Members:
//Saiesha Sharma: saieshar@iu.edu
//Megan Pitts: megpitts@iu.edu
//App Name: Bullet Journal
//Submission Date: 4/25/23

import UIKit

class PastEntriesTableViewController: UITableViewController {
    
    //the model
    var theAppDelegate: AppDelegate?
    var journal: JournalEntriesModel = JournalEntriesModel()

    override func viewWillAppear(_ animated: Bool) {
        
        //reload table data
        if let tempMyTableView = self.view as? UITableView {
            tempMyTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //the model
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        if let journalModel = self.theAppDelegate?.theModel {
            self.journal = journalModel
        } else {
            print("Fail")
        }
        
        
        tableView.rowHeight = 242
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //number of rows = numer of entries
        return self.journal.getJournalEntries().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pastEntriesCell", for: indexPath) as! PastEntriesTableViewCell

        // Configure the cell...
        let entry = self.journal.getJournalEntries()[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        cell.dateLabel.text = dateFormatter.string(from: entry.getDate())
        cell.moodLabel.text = entry.getMood()
        cell.notesText.text = entry.getNotes()
        cell.recipeLabel.text = entry.getRecipe()
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
