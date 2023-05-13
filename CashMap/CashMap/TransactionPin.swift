//
//  TransactionPin.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit
import MapKit

class TransactionPin: NSObject, MKAnnotation {
    let title: String?
    let amount: Float?
    let coordinate: CLLocationCoordinate2D
    let transactions: [Transaction]
    
    init(title: String?, amount: Float?, coordinate: CLLocationCoordinate2D, transactions: [Transaction]) {
        self.title = title
        self.amount = amount
        self.coordinate = coordinate
        self.transactions = transactions
        
        super.init()
    }
    
    var subtitle: String? {
        return NumberFormatter.localizedString(from: NSNumber(value: self.amount ?? 0), number: .currency)
    }
}
