//
//  ViewController.swift
// Ivy Richardson ivrichar
// Camile Tong camitong
// TravelDiary
// submission date: 4/28/2023
//

import UIKit
import CoreData
import CoreLocation

class EditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    @IBOutlet weak var diaryTitle: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var coordinate: UILabel!
    @IBAction func save(_ sender: UIButton) {

        let tempTitle: String = self.diaryTitle.text ?? ""
        let tempContent: String = self.content.text ?? ""
        // clear the input
        self.diaryTitle.text = ""
        self.content.text = ""
        let context = AppDelegate.viewContext
        // create core data object
        var latitude : Double
        var longitude : Double
        if let currentLocation = locationManager.location{
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
        } else{
            latitude = 0.0
            longitude = 0.0
        }
        let entry: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Diaries", into: context)
        entry.setValue(tempTitle, forKey: "title")
        entry.setValue(tempContent, forKey: "content")
        entry.setValue(longitude, forKey: "longitude")
        entry.setValue(latitude, forKey: "latitude")
        // writting to persistent memory
        do {
            try context.save()
            print("Insert new diary \(tempTitle) successful")
        } catch {
            print("error occurs in saving process")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.diaryTitle.delegate = self
        self.content.delegate = self
       
        // info from here: https://developer.apple.com/documentation/corelocation/cllocationmanager/1423687-location
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        var latitude : Double
        var longitude : Double
        if let currentLocation = locationManager.location{
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
        } else{
            latitude = 0.0
            longitude = 0.0
        }
        coordinate.numberOfLines = 2
        coordinate.text = String(latitude) + "\n" + String(longitude)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.diaryTitle.delegate = self
        self.content.delegate = self
       
        // info from here: https://developer.apple.com/documentation/corelocation/cllocationmanager/1423687-location
        locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        var latitude : Double
        var longitude : Double
        if let currentLocation = locationManager.location{
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
        } else{
            latitude = 0.0
            longitude = 0.0
        }
        coordinate.text = String(latitude) + "\n" + String(longitude)
    }
    
    // When return key is hit, the text field keyboard should disappear
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.diaryTitle.resignFirstResponder()
    }
    
    // When return key is hit, the text view keyboard should disappear
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

