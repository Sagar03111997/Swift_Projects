//
//  TableViewController.swift
// Ivy Richardson ivrichar
// Camile Tong camitong
// TravelDiary
// submission date: 4/28/2023
//

import UIKit
import CoreData
import MessageUI

class ViewTableViewController: UITableViewController, emailSendDelegate, MFMailComposeViewControllerDelegate {
    func didTapButton(in cell: TableViewCell) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
                
        mailComposeViewController.setSubject(cell.diaryTitle.text ?? "No Title")
        mailComposeViewController.setMessageBody("\(cell.content.text ?? "No Content") \n Coordinate: \(cell.coordinate.text!)", isHTML: false)
        print("Send email to, \(cell.diaryTitle.text ?? "No Title") \n ********** \(cell.content.text ?? "No Content")")
                
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            print("Error in sending email")
        }
    }
    
    var count = 0
    var diaries = [Diaries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add observer to receive the delete notification, refresh the view
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateCell), name: NSNotification.Name(rawValue: "deleteData"), object: nil)
        // access context
        let context = AppDelegate.viewContext
        //let context = container.viewContext
        let fetchDiaries = NSFetchRequest<Diaries>(entityName: "Diaries")
        do {
            self.diaries = try context.fetch(fetchDiaries)
            self.count = diaries.count
            print("Diaries count: \(count)")
        } catch {
            print("error in fetching data")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        // add delegate
        cell.delegate = self
        let data = diaries[indexPath.row]
        cell.diaryTitle?.text = data.title
        cell.content?.text = data.content
        let lat = data.latitude
        let long = data.longitude
        cell.coordinate?.numberOfLines = 2
        cell.coordinate?.text = String(lat) + "\n" + String(long)
        return cell
    }
    
    @objc func updateCell() {
        viewWillAppear(true)
    }
    
    // refresh every time switching to the tab
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.rowHeight = 200.0
        
        // access context
        let context = AppDelegate.viewContext
        let fetchDiaries = NSFetchRequest<Diaries>(entityName: "Diaries")
        do {
            self.diaries = try context.fetch(fetchDiaries)
            self.count = diaries.count
            print("Diaries count: \(count)")
        } catch {
            print("error in fetching data")
        }
        
        if let myTableView = self.view as? UITableView {
            myTableView.reloadData()
        }
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
