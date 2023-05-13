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

class MatchCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
