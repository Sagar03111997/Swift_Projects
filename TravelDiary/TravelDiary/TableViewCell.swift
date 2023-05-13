//
//  TableViewCell.swift
// Ivy Richardson ivrichar
// Camile Tong camitong
// TravelDiary
// submission date: 4/28/2023
//

import UIKit
import CoreData
import MessageUI

protocol emailSendDelegate: AnyObject {
    func didTapButton(in cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    weak var delegate: emailSendDelegate?
    @IBOutlet weak var diaryTitle: UILabel!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var coordinate: UILabel!
    
    // Cell protocol function
    @IBAction func emailButton(_ sender: UIButton) {
        delegate?.didTapButton(in: self)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        // fetch data
        let context = AppDelegate.viewContext
        let fetchDiaries = NSFetchRequest<Diaries>(entityName: "Diaries")
        // find
        fetchDiaries.predicate = NSPredicate(format: "title == %@ AND content == %@", self.diaryTitle.text!, self.content.text!)
        // delete
        do {
            let diary = try context.fetch(fetchDiaries)
            print("Find and delete entry \(self.diaryTitle.text!)")
            context.delete(diary[0])
            if context.hasChanges {
                try context.save()
                print("Delete change has been saved")
            }
        } catch {
            print("Error in delete: \(error)")
        }
        // notify to refresh table
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deleteData"), object: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
