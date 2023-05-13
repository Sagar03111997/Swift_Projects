//
//  Transaction.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import Foundation
import MapKit

class Location: NSObject, Codable {
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
        
        super.init();
    }
}

class Transaction: NSObject, Codable {
    
    var name: String
    var amount: Float
    var category: String
    var location: Location
    var timestamp: Date
    
    init(
        name: String, 
        amount: Float, 
        category: String, 
        location: Location, 
        timestamp: Date
    ) {
        self.name = name
        self.amount = amount
        self.category = category
        self.location = location
        self.timestamp = timestamp

        super.init()
    }
}

class Transactions: NSObject, Codable {
    
    var transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
        
        super.init();
    }
}

class TransactionCategory {
    
    var category: String
    var transactions = [Transaction]()
    
    init(category: String, transactions: [Transaction] = [Transaction]()) {
        self.category = category
        self.transactions = transactions
    }
}

class TransactionGroup {
    
    var location: Location
    var transactions = [Transaction]()
    
    init(location: Location, transactions: [Transaction] = [Transaction]()) {
        self.location = location
        self.transactions = transactions
    }
}
