//
//  ReviewViewController.swift
//  VocabLearning
//
//  Created by 庞景文 on 4/13/23.
//

/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */

import UIKit
import CoreData
import SpriteKit


class ReviewViewController: UIViewController {
    
    @IBOutlet weak var GroupSelect: UIButton!
    
    var lAppDelegate: AppDelegate?
    var lVocabContext: NSManagedObjectContext?
    var vocabGroups: [VocabularyGroup] = []
    var allVocabs: [Vocab] = []
    var currentVocab: Vocab?
    var skView: SKView?
    var starScene: MyScene?
    
    
    
    @IBOutlet weak var emoji: UILabel!
    
    @IBOutlet weak var VocabLabel: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lAppDelegate = UIApplication.shared.delegate as? AppDelegate
        lVocabContext = lAppDelegate?.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<VocabularyGroup> = VocabularyGroup.fetchRequest()
        do {
            vocabGroups = try lVocabContext?.fetch(fetchRequest) ?? []
        } catch {
            print("Error fetching vocab groups: \(error)")
        }
        
        let fetchRequest2: NSFetchRequest<Vocab> = Vocab.fetchRequest()
        do {
            allVocabs = try lVocabContext?.fetch(fetchRequest2) ?? []
        } catch {
            print("Error fetching vocabs: \(error)")
        }
        
        selectRandomVocab()
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func selectRandomVocab() {
        guard let context = lVocabContext else { return }
        
        // Select a random vocab
        let fetchRequest: NSFetchRequest<Vocab> = Vocab.fetchRequest()
        fetchRequest.predicate = NSPredicate(value: true)
        if let randomVocab = try? context.fetch(fetchRequest).randomElement() {
            currentVocab = randomVocab
        }
        
        // Set the vocab label
        VocabLabel.text = currentVocab?.vocabulary
        
        // Create an array of possible translations (including the correct one)
        var possibleTranslations = [currentVocab?.translation, "", "", ""]
        
        // Create an array of all translations and remove the current vocab's translation
        var allTranslations = allVocabs.compactMap { $0.translation }
        allTranslations.removeAll { $0 == currentVocab?.translation }
        
        // Select 3 random translations from the updated array
        for index in 1...3 {
            if let randomTranslation = allTranslations.randomElement() {
                possibleTranslations[index] = randomTranslation
                allTranslations.removeAll { $0 == randomTranslation }
            }
        }
        
        
        // Shuffle the array of possible translations
        possibleTranslations.shuffle()
        
        // Set the option buttons' titles
        option1.setTitle(possibleTranslations[0], for: .normal)
        option2.setTitle(possibleTranslations[1], for: .normal)
        option3.setTitle(possibleTranslations[2], for: .normal)
        option4.setTitle(possibleTranslations[3], for: .normal)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        selectRandomVocab()
        skView?.removeFromSuperview()
        
        emoji.text = "  "
    }
    
    
    @IBAction func optionButtonTapped(_ sender: UIButton) {
        if sender.title(for: .normal) == currentVocab?.translation {
            print("Good!")
            
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 50))
            containerView.center = CGPoint(x: 50, y: 130)
            view.addSubview(containerView)
            
            // Create the SKView and add it to the container view
            skView = SKView(frame: containerView.bounds) // Assign to the instance variable
            skView?.backgroundColor = UIColor.clear
            containerView.addSubview(skView!)
            
            // Set up the scene and present it in the SKView
            let sceneSize = CGSize(width: 700, height: 100) // adjust as needed
            let myScene = MyScene(size: sceneSize)
            myScene.scaleMode = .aspectFill
            skView?.presentScene(myScene)
            
            emoji.text = "🥳✨🤓✨🤩"
            
        } else {
            print("Wrong.")
            emoji.text = "🤣👉🤡👈😂"
        }
    }
    
    
    class MyScene: SKScene {
        override func didMove(to view: SKView) {
            // Adjust size of the scene's frame
            self.size = CGSize(width: 500, height: 500)
            self.backgroundColor = SKColor.clear
            
            let starTexture = SKTexture(imageNamed: "Star2")
            let star1 = SKSpriteNode(texture: starTexture)
            star1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            star1.position = CGPoint(x: self.frame.midX - 15, y: self.frame.midY)
            star1.size = CGSize(width: star1.size.height * 0.025, height: star1.size.height * 0.025)
            self.addChild(star1)
            
            let star2 = SKSpriteNode(texture: starTexture)
            star2.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            star2.position = CGPoint(x: self.frame.midX + 215, y: self.frame.midY)
            star2.size = CGSize(width: star2.size.height * 0.025, height: star2.size.height * 0.025)
            self.addChild(star2)
            
            let rotateAction = SKAction.rotate(byAngle: CGFloat.pi, duration: 2.0)
            star1.run(SKAction.repeatForever(rotateAction))
            star2.run(SKAction.repeatForever(rotateAction))
        }
    }
}







    
