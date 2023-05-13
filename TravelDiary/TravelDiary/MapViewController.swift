//
//  MapViewController.swift
// Ivy Richardson ivrichar
// Camile Tong camitong
// TravelDiary
// submission date: 4/28/2023
//

import UIKit
import MapKit
import CoreLocation
import CoreData
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    let ourLocationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        print("124")
        super.viewDidLoad()
        self.ourLocationManager.requestWhenInUseAuthorization()
        if(CLLocationManager.locationServicesEnabled()){
            self.ourLocationManager.delegate = self
            self.ourLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.ourLocationManager.startUpdatingLocation()
            //self.ourLocationManager.
            
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
        let context = AppDelegate.viewContext
        //print("location manager accessed")
        let fetchDiaries = NSFetchRequest<Diaries>(entityName: "Diaries")
        do {
            let diaries = try context.fetch(fetchDiaries)
            var i = 0
            for entry in diaries{
                let latitude = entry.latitude
                let longitude = entry.longitude
                let pointToAdd = LocationPoint(lat: latitude, long: longitude)
                //var annotation = MKAnnotation(coordinate)
                mapView.addAnnotation(pointToAdd)
                print("annotation added")
                if i == 0{
                    mapView.setCenter(pointToAdd.coordinate, animated: true)
                }
                i += 1
            }
        } catch {
            print("error in fetching data")
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let context = AppDelegate.viewContext
        print("location manager accessed")
        let fetchDiaries = NSFetchRequest<Diaries>(entityName: "Diaries")
        do {
            let diaries = try context.fetch(fetchDiaries)
            for entry in diaries{
                let latitude = entry.latitude
                let longitude = entry.longitude
                let pointToAdd = LocationPoint(lat: latitude, long: longitude)
                //var annotation = MKAnnotation(coordinate)
                mapView.addAnnotation(pointToAdd)
                print("annotation added")
            }
        } catch {
            print("error in fetching data")
        }
    }
    
    func getCurrentLocation() -> CLLocation {
        if let location = mapView.userLocation.location{
            return location
        } else{
            return CLLocation(latitude: 0, longitude: 0)
        }
    }
    
}

class LocationPoint: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    init(lat: Double, long: Double){
        self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    
}
