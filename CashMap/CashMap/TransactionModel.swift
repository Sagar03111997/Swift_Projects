//
//  TransactionModel.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import Foundation
import MapKit

class TransactionsModel {
    
    public var state = Transactions(transactions:[Transaction]())
    private var categorizedTransactions = [TransactionCategory]()
    
    // Methods
    
    func loadTransactions() {
        // Load transactions from File System
        
       do {
           let fm = FileManager.default
           let docsURL = try fm.url(for:.documentDirectory, in:.userDomainMask, appropriateFor: nil, create: false)

           let transactionsFile = docsURL.appendingPathComponent("transactions.plist")
           let transactionsData = try Data(contentsOf: transactionsFile)
           let result = try PropertyListDecoder().decode(Transactions.self, from: transactionsData)

           state = result
       } catch {
           state = Transactions(transactions: [Transaction]())
          
       }
                
        self.categorizeTransactions()
    }
    
    func saveTransactions() {
        do {
            let fm = FileManager.default
            let docsURL = try fm.url(for:.documentDirectory, in:.userDomainMask, appropriateFor: nil, create: false)
            
            let transactionsFile = docsURL.appendingPathComponent("transactions.plist")
            let transactionsData = try PropertyListEncoder().encode(state)

            try transactionsData.write(to: transactionsFile, options: .atomic)
            
            // to user defaults in shared appgroup for widget extension
            let transactionData = try! JSONEncoder().encode(state)
            UserDefaults(suiteName:
            "group.edu.indiana.cs.c323-")!.set(transactionData, forKey: "purchases")
        } catch {
            print(error)
        }
        
    
    }
    
    func getTransactions() -> [Transaction] {
        return self.state.transactions
    }
    
    func getTransactionsAfter(_ timestamp: Date) -> [Transaction] {
        return self.state.transactions.filter{ $0.timestamp >= timestamp }
    }
    
    func getGroupedTransactions() -> [TransactionGroup] {
        var grouped = [TransactionGroup]()
        var remainingTransactions = Set(self.state.transactions)
        
        // Implement basic clustering algorithm to group any purchases made within 5 meters of each other
        while !remainingTransactions.isEmpty {
            let baseLocation = remainingTransactions.first!
            var cluster = [baseLocation]
            remainingTransactions.remove(baseLocation)
            
            // In meters
            let distanceThreshold: CLLocationDistance = 5
            
            var i = 0
            while i < cluster.count {
                let currentLocation = CLLocation(latitude: cluster[i].location.latitude, longitude: cluster[i].location.longitude)
                let nearbyLocations = remainingTransactions.filter{
                    let location = CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude)
                    return location.distance(from: currentLocation) < distanceThreshold
                }
                
                cluster.append(contentsOf: nearbyLocations)
                remainingTransactions.subtract(nearbyLocations)
                
                i += 1
            }
            
            grouped.append(TransactionGroup(location: baseLocation.location, transactions: cluster))
        }
        
        return grouped
    }
    
    func getCategorizedTransactions() -> [TransactionCategory] {
        return self.categorizedTransactions
    }
    
    func getTransactionsByCoords(_ location: CLLocation) -> [Transaction] {
        // Given in meters
        let proximityThreshold: CLLocationDistance = 500
        
        return state.transactions.filter { CLLocation(latitude: $0.location.latitude, longitude: $0.location.longitude).distance(from: location) <= proximityThreshold }
    }
    
    func addTransaction(_ transaction: Transaction) {
        self.state.transactions.append(transaction)
        
        self.saveTransactions()
        self.categorizeTransactions()
    }
    
    func removeTransaction(_ transaction: Transaction) {
        guard
            let removeIndex = state.transactions.firstIndex(where: { $0 === transaction })
        else { return }
        
        self.state.transactions.remove(at: removeIndex)
        
        self.saveTransactions()
        self.categorizeTransactions()
    }
    
    func clearTransactions() {
        self.state.transactions = []
        
        self.saveTransactions()
        self.categorizeTransactions()
    }
    
    // Helpers
    
    private func categorizeTransactions() {
        var categories = [TransactionCategory]()
                
        for transaction in self.state.transactions {
            if let index = categories.firstIndex(where: { $0.category == transaction.category }) {
                if !categories[index].transactions.contains(where: { $0.name == transaction.name && $0.timestamp == transaction.timestamp }) {
                    categories[index].transactions.append(transaction)
                    categories[index].transactions = categories[index].transactions.sorted{ $0.timestamp < $1.timestamp }
                }
            } else {
                categories.append(TransactionCategory(category: transaction.category, transactions: [transaction]))
            }
        }
                
        self.categorizedTransactions = categories
    }
}
