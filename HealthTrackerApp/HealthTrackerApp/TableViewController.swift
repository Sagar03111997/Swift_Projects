//Health Tracker
//Deecon Precht
    //dgprecht@iu.edu
//Nicholas Van Burk
    //ndvanbur@iu.edu
//28 APR 2023
import UIKit

class TableViewController: UITableViewController {
    
    var appDelegate: AppDelegate?
    var model: User?
    
    @IBOutlet var table: UITableView!

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.goals.count ?? 0 // rows = # of goals user has added
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? TableViewCell
        // Configure the cell...
        let df = DateFormatter()
        // formatting the date styles
        df.dateStyle = .medium
        df.timeStyle = .medium
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "MM/dd/yy', 'HH:mm a"
        // setting each label to the corresponding goal and date
        if let mdl = model{
            let goal = mdl.getGoal(index: indexPath.row)
            cell!.goalLabel.text = goal.title
            cell!.dateLabel.text = goal.date!.formatted()
        }
            
            return cell!
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
        if let mdl = model {
            mdl.reloadGoals();
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        table.reloadData()
    }
}
