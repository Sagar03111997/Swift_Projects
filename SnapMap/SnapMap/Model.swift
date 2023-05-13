//
//  Model.swift
//  SnapMap
//
//  Created by Gonzalo Cruz Cortes and Andreas Papaioannou on 4/15/23.
//

import UIKit
import CoreLocation
import MapKit

class Model {
    static let shared = Model()
    private let dataKey = "LocationData"
    
    var locations: [LocationItem] = []
    
    private init() {
        loadLocations()
    }
    
    func addLocation(image: UIImage, coordinates: CLLocationCoordinate2D, description: String) {
        let locationItem = LocationItem(imageData: image.pngData()!, latitude: coordinates.latitude, longitude: coordinates.longitude, descriptionText: description)
        locations.append(locationItem)
        saveLocations()
    }
    
    func updateLocationCounts(at index: Int, heartCount: Int? = nil, paperAirplaneCount: Int? = nil, globeCount: Int? = nil) {
        if let heartCount = heartCount {
            locations[index].heartCount = heartCount
        }
        if let paperAirplaneCount = paperAirplaneCount {
            locations[index].paperAirplaneCount = paperAirplaneCount
        }
        if let globeCount = globeCount {
            locations[index].globeCount = globeCount
        }
        saveLocations()
    }

    private func saveLocations() {
        if let encodedData = try? JSONEncoder().encode(locations) {
            UserDefaults.standard.set(encodedData, forKey: dataKey)
        }
    }
    
    private func loadLocations() {
        if let savedData = UserDefaults.standard.data(forKey: dataKey) {
            if let decodedData = try? JSONDecoder().decode([LocationItem].self, from: savedData) {
                locations = decodedData
            }
        }
    }
}


class LocationItem: NSObject, Codable, MKAnnotation {
    var imageData: Data
    var latitude: Double
    var longitude: Double
    var descriptionText: String
    var heartCount: Int
    var paperAirplaneCount: Int
    var globeCount: Int

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return descriptionText
    }
    
    init(imageData: Data, latitude: Double, longitude: Double, descriptionText: String, heartCount: Int = 0, paperAirplaneCount: Int = 0, globeCount: Int = 0) {
        self.imageData = imageData
        self.latitude = latitude
        self.longitude = longitude
        self.descriptionText = descriptionText
        self.heartCount = heartCount
        self.paperAirplaneCount = paperAirplaneCount
        self.globeCount = globeCount
        super.init()
    }
}
