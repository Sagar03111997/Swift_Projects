//
//  ViewSpendsTableViewController.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit

protocol TransactionSelectionDelegate: AnyObject {
    func transactionSelected(_ newTransaction: Transaction)
    func showCurrentLocation()
}

class SpendsTableViewController: UITableViewController {

    var model: TransactionsModel?
    var transactions = [TransactionCategory]()
    
    weak var delegate: TransactionSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = (UIApplication.shared.delegate as? AppDelegate)?.transactionsModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load transactions data
        self.transactions = model?.getCategorizedTransactions() ?? []
        self.tableView.reloadData()
    }
    
    /* TABLE METHODS */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions[section].transactions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return transactions[section].category
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! SpendsTableViewCell
        
        let transaction = transactions[indexPath.section].transactions[indexPath.row]
        cell.nameLabel?.text = transaction.name
        cell.amountLabel?.text = String(format: "$%0.2f", transaction.amount)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactions[indexPath.section].transactions[indexPath.row]
        delegate?.transactionSelected(selectedTransaction)
        
        if let detailViewController = delegate as? CashMapViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.model?.removeTransaction(self.transactions[indexPath.section].transactions[indexPath.row])
            self.transactions = model?.getCategorizedTransactions() ?? []
        }
        
        self.tableView.reloadData()
    }
    
    // ACTIONS
    
    @IBAction func goToCurrentLocation() {
        delegate?.showCurrentLocation()
        
        if let detailViewController = delegate as? CashMapViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
        }
    }
    
    @IBAction func clearTransactions() {
        self.model?.clearTransactions()
        self.transactions = model?.getCategorizedTransactions() ?? []
        
        self.tableView.reloadData()
    }
}
