/*
 1.
  Usernames:
  Matthew Clark (matkclar)
  Sasha Velet (svelet)
  Matthew Hammans (mmhamman)
 
 2. FoeFinder
 
 3. 04/28/2023
 */

import UIKit
import MapKit

// only for the purpose of getting coordinates for location


class MappedViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var myAppDelegate : AppDelegate?
    var myUserModel : UserModel?
    
    // manages current user's location
    let locationManager = CLLocationManager()
    
    // map view
    @IBOutlet weak var LocationMapped: MKMapView!
    // displays current amount of enemies nearby
    @IBOutlet weak var totalEnemiesLbl: UILabel!
    
    // store user's coordinates
    var longitude : Double = 0.0
    var latitude : Double = 0.0
    
    // make it global variable
    var userAnnotation = MKPointAnnotation()
    
    // currently displayed
    var currentAnnotations = [MKAnnotation]()
    var isLocationAuthorized : Bool = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.locationManager.requestWhenInUseAuthorization()
        LocationMapped.removeAnnotations(currentAnnotations)
        // removes current annotations
        if (isLocationAuthorized) {
            // regenerate annotations evereytime user refreshes
            // illusion of foes appearing/reappearing
            generateAnnotations(longitude: self.longitude, latitude: self.latitude)
        } else {
            self.locationManager.stopUpdatingLocation()
            totalEnemiesLbl.text = "Enemies near you: -"
        }
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ... if user authorized location services,
        //     we can tell the Location Manager
        //     to use this View Controller as delegate,
        //     configure accuracy, start updating location, etc ...
        if (locationManager.authorizationStatus == .authorizedAlways ||
            locationManager.authorizationStatus == .authorizedWhenInUse) {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            isLocationAuthorized = true
        } else {
            self.locationManager.stopUpdatingLocation()
            LocationMapped.removeAnnotations(currentAnnotations)
        }
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // Handle authorized status change
            isLocationAuthorized = true
            self.locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Handle denied status change
            isLocationAuthorized = false
            locationManager.requestWhenInUseAuthorization()
            // Show an alert to the user explaining how to enable location access
            // (as shown in my previous answer)
        case .notDetermined:
            // Handle undetermined status change
            isLocationAuthorized = false
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            fatalError("Unhandled authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           
        let current: CLLocation = locations.first!
        self.longitude = current.coordinate.longitude
        self.latitude = current.coordinate.latitude
      
        // add user red pin & random generated foes
        if(isLocationAuthorized){
            generateAnnotations(longitude: self.longitude, latitude: self.latitude)
            NotificationManager.shared.latitude = latitude
            NotificationManager.shared.longitude = longitude
        }
        
        }
    
    func generateAnnotations(longitude : Double, latitude : Double) {
        
        // The MKAnnotation object specifies the position coordinates, title, etc.
        // the view: an MKAnnotationView object (the pin itself)
        
        var allAnnotations = [MKAnnotation]()
        // create user's annotation
        userAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        userAnnotation.title = "Your location"
        userAnnotation.subtitle = myUserModel?.profileCurrentlyLoggedIn?.userName
        
        allAnnotations.append(userAnnotation)
        
        // generate a random amount of foe's near the users area
        let foesNearYou = Int.random(in: 1...20)
    
        
        // create MkPointAnnotation Objects
        for i in 1...foesNearYou {
            
            // add random offsets to current long/lat
            let latOffset = Double.random(in: -0.01...0.01)
            let lonOffset = Double.random(in: -0.01...0.01)
            let newLat = latitude + latOffset
            let newLon = longitude + lonOffset
            
            // Create a new coordinate from the offset values
            let randomAnnotation = MKPointAnnotation()
            randomAnnotation.coordinate = CLLocationCoordinate2D(latitude: newLat, longitude: newLon)
            randomAnnotation.title = "Foe #\(i)"
            randomAnnotation.subtitle = "Foe's location"
            
            allAnnotations.append(randomAnnotation)
        }
        
        LocationMapped.addAnnotations(allAnnotations) // add all locations to map
        currentAnnotations = allAnnotations // save all annotations to currently displayed
        totalEnemiesLbl.text = "Total Enemies Nearby: \(foesNearYou)"
        
        // zoom into user's current region everytime 
        zoomIntoRegion()
    }
    
    func zoomIntoRegion(){
        let region = MKCoordinateRegion(center: userAnnotation.coordinate,latitudinalMeters: 2200, longitudinalMeters: 2200)
        // change ciurrent view to users location location
        LocationMapped.setCenter(userAnnotation.coordinate, animated: true)
        // change region "zooms" into users location
        LocationMapped.setRegion(region, animated: true)
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
