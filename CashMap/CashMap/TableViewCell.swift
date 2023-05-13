//
//  SpendsTableViewCell.swift
//  CashMap
//
//Luke Atkins and Zach Watson
//lukeatki@iu.edu & watsonz@iu.edu
//CashMap (April 30th 2023)

import UIKit

class SpendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var amountLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
