//
//  AddSpendViewController.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit
import CoreLocation

class AddSpendViewController: UIViewController, CLLocationManagerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var appDelegate : AppDelegate?
    var myTransactionsModel : TransactionsModel?
    
    //location
    let locationManager = CLLocationManager()
    
    // food, ent, ride, cloths, house, alc, coff, groc
    var catagories : [String] = ["Food", "Entertainment", "Rides", "Cloths","House", "Alcohol", "Coffee", "Groceries"]
    var catagoryFlags : [Bool] = [false,false,false,false,false,false,false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let appDelegate =  UIApplication.shared.delegate as? AppDelegate{
            self.appDelegate = UIApplication.shared.delegate as? AppDelegate
            if let myTransactionsModel = self.appDelegate?.transactionsModel{
                self.myTransactionsModel = self.appDelegate?.transactionsModel
              
            }
            else{
                print("error with the transaction model")
            }
        }
        else{
            print("error with appdelegate")
        }
        
        
        //location
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reset selected catagories
        self.catagoryFlags = [false,false,false,false,false,false,false,false]
        //rest message label to guide user
        messageLabel.text = "Add a category, price, and name..."
        print("entry view appeard")
        // reset all button colors when user comes back to screen
        for k in 1...catagoryFlags.count{
            let button = view.viewWithTag(k) as? UIButton
            button?.tintColor = UIColor.lightGray
            button?.layer.cornerRadius = 10
        }
        
    
    }
    
    //filter was pressed
    @IBAction func filterButtonPressed(_ sender: UIButton){
        catagoryFlags[sender.tag - 1] = true
    
       
        for k in 1...catagoryFlags.count{
            if k != sender.tag{
                catagoryFlags[k-1] = false
                let button = view.viewWithTag(k) as? UIButton
                button?.tintColor = UIColor.lightGray
            }
            else{
                catagoryFlags[k-1] = true
                let button = view.viewWithTag(k) as? UIButton
                button?.tintColor = UIColor.white
                
            }
          
        }
       
    }
    
    //price enterd
    
    @IBOutlet weak var priceNumberEntry: UITextField!
    // what is this entry
    @IBOutlet weak var descriptionTextEntry: UITextField!
    // notify user of need information
    @IBOutlet weak var messageLabel: UILabel!
    //add purchase button
    @IBAction func addPurchaseButton(_ sender: Any) {
        
        // add transaction to model with correct catagory
        // description, location, and price, and time stamp
        // check for descrition and catagory. if no price given, its was free
        
        if descriptionTextEntry.text == ""{
            messageLabel.text = "Please write what this is for..."
            return
        }
        var catagory : Int = 0
        var selectedCatagory : Bool = false
        for i in 0...catagoryFlags.count - 1{
            if catagoryFlags[i]{
                selectedCatagory = true
                catagory = i
            }
        }
        if !selectedCatagory{
            messageLabel.text = "Please select a catagory first.."
            return
        }
        // check for current moent
        var price : Float = 0.00
        if priceNumberEntry.text == ""{
            price = 0.00
        }
        else{
            price = Float(priceNumberEntry.text!) ?? 0.00
        }
        
    
        // codable needs locations not CLLocation
        let local : Location = Location(latitude: self.locationManager.location?.coordinate.latitude ?? 0, longitude: self.locationManager.location?.coordinate.longitude ?? 0)
        let currentTransaction: Transaction = Transaction(name: descriptionTextEntry.text!, amount: price, category: catagories[catagory], location: local, timestamp: Date())
        
        // checks are done, create and add the transaction
        descriptionTextEntry.text = ""
        priceNumberEntry.text = "0.00"
        myTransactionsModel?.addTransaction(currentTransaction)
        self.catagoryFlags = [false,false,false,false,false,false,false,false]
        messageLabel.text = "Add a category, price, and name..."
        //WidgetCenter.shared.reloadAllTimelines()
        
    }
}
