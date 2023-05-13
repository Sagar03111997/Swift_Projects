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

class LogInViewController: UIViewController {
    
    var myAppDelegate : AppDelegate?
    var myUserModel : UserModel?
    
    //let LoggedInView  = Main.storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    
    @IBAction func LoginPressed(_ sender: Any) {
        //Find if the correct username is in the model
        var i: Int = 0
        for userName in myUserModel!.loginInfo.userNames {
            if userName == userNameTextField.text! {
                break;
            } else {
                i += 1
            }
        }
        
        // Looking for the password
        
         if myUserModel!.loginInfo.passWords[i] != passWordTextField.text! {
            // password not found
            return
        }
        
        // Assumes both username and password are correct by this point and logs in
        myUserModel!.login(loginProfile: myUserModel!.loginInfo.profiles[i])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        self.present(mainTabBarController, animated: true, completion: nil)
        
    }
    
    @IBAction func CreateAccountPressed(_ sender: Any) {
        print("something")
        myUserModel!.loginInfo.userNames.append(userNameTextField.text!)
        myUserModel!.loginInfo.passWords.append(passWordTextField.text!)
        
        let tempImage = UIImage(named: "stock1")!
        let tempProfile = Profile(userImage: tempImage, first : "firstName", last : "LastName",
                                  day : 1, month : 1, year : 2001,
                                  likes: ["Evil"], dislikes: ["Good"])
        
        myUserModel!.loginInfo.profiles.append(tempProfile)
        
        myUserModel!.login(loginProfile: tempProfile)
        
        print("something")
        
        //print("view controllers: \(self.navigationController!.viewControllers)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
        mainTabBarController.modalPresentationStyle = .fullScreen
        
        self.present(mainTabBarController, animated: true, completion: nil)
    }
    
    

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
