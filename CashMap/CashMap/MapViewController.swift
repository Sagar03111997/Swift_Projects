//
//  ViewController.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)


import UIKit
import MapKit

class CashMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, TransactionSelectionDelegate {
    
    var model: TransactionsModel?
    var notificationHelper: NotificationHelper?
    let locationManager = CLLocationManager()
    
    var transactions = [TransactionGroup]()
    
    @IBOutlet weak var mapView: MKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.model = (UIApplication.shared.delegate as? AppDelegate)?.transactionsModel
        self.notificationHelper = (UIApplication.shared.delegate as? AppDelegate)?.notifHelper
        
        // Configure MapView
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        mapView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
                
        // Handle Permissions
        self.locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()){
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        // Setup MapView delegate
        mapView?.delegate = self
        mapView?.mapType = .standard
        mapView?.isZoomEnabled = true
        mapView?.isScrollEnabled = true
        mapView?.showsUserLocation = true
        
        // Center around user initially
        if let crds = self.locationManager.location?.coordinate {
            let userRegion = MKCoordinateRegion(
                center: crds,
                latitudinalMeters: 200,
                longitudinalMeters: 200
            )
            mapView?.setRegion(userRegion, animated: false)
            
            // Handle sending frequency notification if timeout has ended and conditions are met
            let nearbyTransactions = self.model?.getTransactionsByCoords(
                CLLocation(latitude: crds.latitude, longitude: crds.longitude)
            )
            
            guard let thresholdDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return }
            let recentTransactions = nearbyTransactions?.filter{ $0.timestamp >= thresholdDate }
            
            if recentTransactions?.count ?? 0 > 5 {
                self.notificationHelper?.createNotification("Frequent Transactions", "You have \(recentTransactions?.count ?? 0) transactions in this area in the past 7 days")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshAnnotations()
    }
    
    // HANDLERS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.refreshAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "transaction"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: 0, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let transactionGroup = view.annotation as! TransactionPin
        
        for transaction in transactionGroup.transactions {
            print("\(transaction.name): \(transaction.amount)")
        }
    }
    
    // HELPERS
    
    func refreshAnnotations() {
        self.transactions = self.model?.getGroupedTransactions() ?? []

        if let currentAnnotations = mapView?.annotations {
            mapView?.removeAnnotations(currentAnnotations)
        }
        
        var annotations = [MKAnnotation]()

        // Add pins to each transaction aggregate
        for transactionGroup in self.transactions {
            var total: Float = 0
            for transaction in transactionGroup.transactions {
                total += transaction.amount
            }
            
            let pin = TransactionPin(
                title: "\(transactionGroup.transactions.count) Transactions",
                amount: total,
                coordinate: CLLocationCoordinate2D(latitude: transactionGroup.location.latitude, longitude: transactionGroup.location.longitude),
                transactions: transactionGroup.transactions
            )
            annotations.append(pin)
        }
                
        mapView?.addAnnotations(annotations)
    }
    
    func transactionSelected(_ newTransaction: Transaction) {
        let newFocusRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: newTransaction.location.latitude, longitude: newTransaction.location.longitude
            ),
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
        mapView?.setRegion(newFocusRegion, animated: false)
    }
    
    func showCurrentLocation() {
        if let crds = self.locationManager.location?.coordinate {
            let userRegion = MKCoordinateRegion(
                center: crds,
                latitudinalMeters: 200,
                longitudinalMeters: 200
            )
            mapView?.setRegion(userRegion, animated: false)
        }
    }
    
    // ACTIONS
    
    @IBAction func goToAddSpend(_ sender: Any) {
        performSegue(withIdentifier: "goToEntryView", sender: self)
    }
}

