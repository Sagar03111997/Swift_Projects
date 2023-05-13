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

class MessagesViewController: UIViewController {

    var myAppDelegate : AppDelegate?
    var myUserModel : UserModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.myAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myUserModel = self.myAppDelegate?.userModel
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
