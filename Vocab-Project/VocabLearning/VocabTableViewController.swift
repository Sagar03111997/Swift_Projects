//
//  VocabTableViewController.swift
//  VocabLearning
//
//  Created by 庞景文 on 4/13/23.


/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */
//

import UIKit
import CoreData
import AVFoundation

class VocabTableViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var lAppDelegate: AppDelegate?
    var lVocabContext: NSManagedObjectContext?
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        lAppDelegate = UIApplication.shared.delegate as? AppDelegate
        lVocabContext = lAppDelegate?.persistentContainer.viewContext
        
        self.tableView.rowHeight = 160
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        self.tableView.rowHeight = 160
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let fetchRequest: NSFetchRequest<VocabularyGroup> = VocabularyGroup.fetchRequest()
        let results = try? lVocabContext?.fetch(fetchRequest)
        return results?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let fetchRequest: NSFetchRequest<Vocab> = Vocab.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vocabularyGroup.groupName == %@", self.tableView(tableView, titleForHeaderInSection: section) ?? "")
        let count = try? lVocabContext?.count(for: fetchRequest)
        return count ?? 0

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let fetchRequest: NSFetchRequest<VocabularyGroup> = VocabularyGroup.fetchRequest()
        let results = try? lVocabContext?.fetch(fetchRequest)
        return results?[section].groupName ?? ""
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vocabCell", for: indexPath) as! VocabTableViewCell

        // Configure the cell...
        let groupName = self.tableView(tableView, titleForHeaderInSection: indexPath.section) ?? ""
        print("Group name: \(groupName)")

        let fetchRequest: NSFetchRequest<Vocab> = Vocab.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "vocabularyGroup.groupName == %@", groupName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "vocabulary", ascending: true)]

        do {
            let vocabularies = try lVocabContext?.fetch(fetchRequest) ?? []
            print("Vocabularies count: \(vocabularies.count)")

            let vocabulary = vocabularies[indexPath.row]
            cell.VocabNameLabel.text = vocabulary.vocabulary
            cell.TranslationLabel.text = vocabulary.translation
            cell.DefinitionLabel.text = vocabulary.definition
            print(vocabulary.audioFilePath ?? "")
            cell.audioFilePath = vocabulary.audioFilePath

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

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
