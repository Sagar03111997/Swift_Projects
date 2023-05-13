//
//  ViewController.swift
//  SnapMap
//
//  Created by Gonzalo Cruz Cortes and Andreas Papaioannou on 4/13/23.
//

import UIKit
import MapKit
import AVFoundation 

class ViewController: UIViewController, MKMapViewDelegate {
    
    private var mapView: MKMapView!
    private var customView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        addAnnotations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAnnotations()
    }
    
    private func setupMapView() {
        mapView = MKMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        view.addSubview(mapView)
    }
    
    private func addAnnotations() {
        let locationItems = Model.shared.locations
        for item in locationItems {
            mapView.addAnnotation(item)
        }
    }
    
    private func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        addAnnotations()
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let locationItem = annotation as? LocationItem else { return nil }
        
        let identifier = "LocationItemAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: locationItem, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = locationItem
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let locationItem = view.annotation as? LocationItem else { return }
        
        createCustomView(for: locationItem)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        customView?.removeFromSuperview()
    }
    
    private func createCustomView(for locationItem: LocationItem) {
        let screenWidth = view.bounds.width
        let screenHeight = view.bounds.height

        let customViewWidth: CGFloat = screenWidth
        let customViewHeight: CGFloat = screenHeight
        let customViewX: CGFloat = 0
        let customViewY: CGFloat = 0

        customView = UIView(frame: CGRect(x: customViewX, y: customViewY, width: customViewWidth, height: customViewHeight))

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        if let rotatedImage = UIImage(data: locationItem.imageData)?.rotate(radians: .pi/2) {
            imageView.frame = customView.bounds
            imageView.image = rotatedImage
        }
        customView.addSubview(imageView)

        let labelHeight = customViewHeight * 0.10
        let labelSpacing: CGFloat = 10

        let addressLabel = UILabel(frame: CGRect(x: 0, y: customViewHeight - labelHeight * 2 - labelSpacing * 2 - view.safeAreaInsets.bottom, width: customViewWidth, height: labelHeight))
        addressLabel.numberOfLines = 0
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont.systemFont(ofSize: 20)
        addressLabel.textColor = .white
        addressLabel.text = "Address: \(locationItem.coordinate.latitude), \(locationItem.coordinate.longitude)"
        customView.addSubview(addressLabel)

        let descriptionLabel = UILabel(frame: CGRect(x: 0, y: customViewHeight - labelHeight - labelSpacing - view.safeAreaInsets.bottom, width: customViewWidth, height: labelHeight))
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 24)
        descriptionLabel.textColor = .white
        descriptionLabel.text = locationItem.descriptionText
        customView.addSubview(descriptionLabel)

        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .black
        closeButton.layer.cornerRadius = 20
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 40
        let buttonTopMargin: CGFloat = 10
        let buttonRightMargin: CGFloat = 10
        closeButton.frame = CGRect(x: customViewWidth - buttonWidth - buttonRightMargin, y: buttonTopMargin + view.safeAreaInsets.top, width: buttonWidth, height: buttonHeight)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        customView.addSubview(closeButton)

        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationItem.coordinate.latitude, longitude: locationItem.coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                addressLabel.text = "Address not found"
                return
            }
            addressLabel.text = placemark.name ?? "Address not found"
        }

        view.addSubview(customView)
    }
    
    
    @objc private func closeButtonTapped() {
        customView?.removeFromSuperview()
    }
}

extension UIImage {
    func rotate(radians: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.height, height: size.width), false, scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Translate to the center of the context
        context.translateBy(x: size.height / 2, y: size.width / 2)
        context.rotate(by: radians)
        context.scaleBy(x: 1.0, y: -1.0)

        // Calculate the origin of the image to center it
        let origin = CGPoint(x: -size.width / 2, y: -size.height / 2)
        
        context.draw(cgImage!, in: CGRect(origin: origin, size: size))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage
    }
}
