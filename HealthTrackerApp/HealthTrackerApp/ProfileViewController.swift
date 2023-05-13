//Health Tracker
//Deecon Precht
    //dgprecht@iu.edu
//Nicholas Van Burk
    //ndvanbur@iu.edu
//28 APR 2023
import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    var appDelegate: AppDelegate?
    var model: User?
    
        // labels
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var goalWeightLabel: UITextField!
    @IBOutlet weak var avgHrLabel: UITextField!
    @IBOutlet weak var currWeightLabel: UITextField!
    
    @IBAction func logWeightButton(_ sender: Any) {
        if let wt = Int(currWeightLabel.text ?? "") {
            if let mdl = model {
                mdl.addWeightMeasurement(measurement: wt)
            }
        }
        currWeightLabel.text = "";
        currWeightLabel.resignFirstResponder()
    }
    // calculate new average heart rate
    @IBAction func logHeartRateButton(_ sender: Any) {
        model?.addHeartRates( hr: Int(avgHrLabel.text!) ?? 0)
        avgHrLabel.text = model?.calculateAvgHr()
        avgHrLabel.resignFirstResponder()
    }
    @IBAction func updateButton(_ sender: Any) {
        model?.firstName = firstNameLabel.text ?? ""
        model?.lastName = lastNameLabel.text ?? ""
        model?.goalWeight = Int(goalWeightLabel.text!) ?? 0
        firstNameLabel.text = ""
        lastNameLabel.text = ""
        goalWeightLabel.text = ""
        goalWeightLabel.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.model = self.appDelegate?.model
    }
}

