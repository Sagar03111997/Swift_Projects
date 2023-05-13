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
import SpriteKit

class MatchViewController: UIViewController {

    var myAppDelegate : AppDelegate?
    var myUserModel : UserModel?
    var possibleMatches : [Profile] = []
    var currentProfile : Profile?
    
    // Outlet for Profile Image
    @IBOutlet weak var matchImage: UIImageView!
    
    @IBOutlet weak var dislikesLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var zodiacLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var match: UIButton!
    @IBOutlet weak var unmatch: UIButton!
    @IBOutlet weak var matchProfilePic: UIImageView!
    
    // Sword Animation Outlet
    @IBOutlet weak var KnifeViewLeft: SKView!
    @IBOutlet weak var KnifeViewRight: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Match View Loaded")

        // Do any additional setup after loading the view.
        self.myAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.myUserModel = self.myAppDelegate?.userModel
        
        // Set Knife Animations as Transparent
        KnifeViewLeft.allowsTransparency = true
        KnifeViewRight.allowsTransparency = true
        
        possibleMatches = self.myUserModel!.profileCurrentlyLoggedIn!.possibleMatches
        currentProfile = possibleMatches.remove(at: 0)
        
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let spinningKnife = setKnifeScene()
        KnifeViewLeft.presentScene(spinningKnife)
        KnifeViewRight.presentScene(spinningKnife)
    }
    
    @IBAction func unmatch(_ sender: Any) {
        // what happens when current user unmatches someone
        
        self.myUserModel!.profileCurrentlyLoggedIn!.rejectedMatches.append(currentProfile!)
        
        changeProfile()
    }
    
    
    @IBAction func match(_ sender: Any) {
        // what hapens when current user matches with someone
        self.myUserModel!.profileCurrentlyLoggedIn!.matches.append(currentProfile!)
        
        for profile in self.myUserModel!.profiles {
            if profile.currentlyLoggedIn == true {
                profile.matches = self.myUserModel!.profileCurrentlyLoggedIn!.matches
            }
        }
        
        changeProfile()
    }
  
    func updateUI() {
        let newImage = currentProfile!.userImage
        matchImage.image = UIImage(data: newImage)
        
        // Set Likes Label
        var likeString: String = ""
        for like in currentProfile!.likes {
            likeString += "\(like), "
        }
        let removevalueLike: Int = likeString.count - 2
        let likeSubString: String = String(likeString.prefix(removevalueLike))
        likesLbl.text = likeSubString
        
        // Set Dislikes Label
        var dislikeString: String = ""
        for dislike in currentProfile!.dislikes {
            dislikeString += "\(dislike), "
        }
        let removeValueDislike: Int = dislikeString.count - 2
        let dislikeSubString: String = String(dislikeString.prefix(removeValueDislike))
        dislikesLbl.text = dislikeSubString
        
        zodiacLbl.text = currentProfile!.zodiacSign
        
        nameLbl.text = "\(currentProfile!.firstName) \(currentProfile!.lastName)"
    }
    
    func changeProfile() {
        if !possibleMatches.isEmpty {
            currentProfile = possibleMatches.remove(at: 0)
        }
        
        myUserModel!.save()
        
        updateUI()
    }
    
    
    func setKnifeScene() -> SKScene {
        // Set Up Scence
        let minimumDimension = min(view.frame.width, view.frame.height)
        let size = CGSize(width: minimumDimension, height: minimumDimension)

        // Create Scene and Allow Transparency
        let scene = SKScene(size: size)
        scene.view?.allowsTransparency = true
        scene.backgroundColor = .clear
        
        // Add Knife Emoji to Scene
        let emoji: Character = "⚔️"
        let node = SKLabelNode()
        node.fontSize = 200
        node.text = String(emoji)
        node.verticalAlignmentMode = .center
        node.horizontalAlignmentMode = .center
        node.position.y = scene.size.height / 2
        node.position.x = scene.size.width / 2
        
        // Add Knife Node to Scene
        scene.addChild(node)

        // Animmate Knife Node to Spin & Grow
        for (index, node) in scene.children.enumerated() {
            node.run(.sequence([
                .wait(forDuration: TimeInterval(index) * 0.1),
                .repeatForever(.sequence([
                    // Each Action Happens at the Same Time
                    .group([
                        .sequence([
                            // Chance to 1.5 Size and Back Rapidly (during Spin)
                            .scale(to: 1.5, duration: 0.3),
                            .scale(to: 1, duration: 0.3)
                        ]),
                        // Spin in a Circle
                        .rotate(byAngle: .pi * 2, duration: 0.6)
                    ]),
                    // Pause for 2 Seconds
                    .wait(forDuration: 2)
                ]))
            ]))
        }
        
        return scene
    }

}
