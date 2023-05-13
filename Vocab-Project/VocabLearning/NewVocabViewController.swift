
/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */



import UIKit
import CoreData
import SpriteKit
import AVFoundation


class NewVocabViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var lAppDelegate: AppDelegate?
    var lVocabContext: NSManagedObjectContext?
    
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var audioFileName : String = "recording.m4a"
    
    @IBOutlet weak var RecordLabel: UIButton!
    @IBOutlet weak var PlayLabel: UIButton!
    
    @IBOutlet weak var NewVocabTextField: UITextField!
    @IBOutlet weak var TranslationTextField: UITextField!
    @IBOutlet weak var DefinitionTextField: UITextField!
    @IBOutlet weak var GroupTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up apple delegate
        lAppDelegate = UIApplication.shared.delegate as? AppDelegate
        lVocabContext = lAppDelegate?.persistentContainer.viewContext
        
        // SpriteKit animation setting
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 700, height: 50))
        containerView.center = CGPoint(x: 50, y: 83)
        view.addSubview(containerView)
        // Create the SKView and add it to the container view
        let skView = SKView(frame: containerView.bounds)
        skView.backgroundColor = UIColor.clear
        containerView.addSubview(skView)
        // Set up the scene and present it in the SKView
        let sceneSize = CGSize(width: 700, height: 100) // adjust as needed
        let myScene = MyScene(size: sceneSize)
        myScene.scaleMode = .aspectFill
        skView.presentScene(myScene)
        _ = SKTexture(imageNamed: "star.png")
        _ = SKAction.rotate(byAngle: CGFloat.pi, duration: 2.0)
        
        
        // av fundation setting
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission { [weak self] allowed in
                if allowed {
                    print("Microphone permission granted")
                } else {
                    print("Microphone permission denied")
                }
            }
        } catch {
            print("Error setting up audio session")
        }
        
        setupRecorder()
        PlayLabel.isEnabled = false

    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    
    func setupRecorder(){
        let audioFilename = getDocumentsDirectory().appendingPathComponent(audioFileName)
        let recordSetting = [ AVFormatIDKey : kAudioFormatAppleLossless,
                   AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
                         AVEncoderBitRateKey: 320000,
                       AVNumberOfChannelsKey: 2,
                             AVSampleRateKey: 44100.2] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
        } catch {
            print(error)
        }
    }
    
    func setupPlayer() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(audioFileName)
        print("player file: \(audioFilename)")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
        } catch {
            print(error)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        PlayLabel.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        RecordLabel.isEnabled = true
        PlayLabel.setTitle("Play", for: .normal)
    }
    
    @IBAction func RecordAction(_ sender: Any) {
        if RecordLabel.titleLabel?.text == "Record"{
            audioRecorder.record()
            RecordLabel.setTitle("Stop", for: .normal)
            PlayLabel.isEnabled = false
        } else {
            audioRecorder.stop()
            RecordLabel.setTitle("Record", for: .normal)
            PlayLabel.isEnabled = true
        }
    }
    
    
    @IBAction func PlayAction(_ sender: Any) {
        if PlayLabel.titleLabel?.text == "Play"{
            PlayLabel.setTitle("Stop", for: .normal)
            RecordLabel.isEnabled = false
            setupPlayer()
            if let player = audioPlayer {
                player.play()
            } else {
                print("Error: Audio player is nil")
            }
        } else {
            if let player = audioPlayer {
                player.stop()
            }
            PlayLabel.setTitle("Play", for: .normal)
            RecordLabel.isEnabled = true
        }
    }
    
    
    

    
    @IBAction func AddNewVocab(_ sender: Any) {
        guard let context = lVocabContext else { return }
        
        let fetchRequest: NSFetchRequest<VocabularyGroup> = VocabularyGroup.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "groupName == %@", GroupTextField.text ?? "Ungrouped")
        let groups = try? context.fetch(fetchRequest)
        let group = groups?.first ?? VocabularyGroup(context: context)
        group.groupName = GroupTextField.text
        
        let vocab = Vocab(context: context)
        vocab.vocabulary = NewVocabTextField.text
        vocab.translation = TranslationTextField.text
        vocab.definition = DefinitionTextField.text
        vocab.vocabularyGroup = group
        
        if let audioURL = audioRecorder?.url {
            let documentsDirectory = getDocumentsDirectory()
            let newAudioFileName = UUID().uuidString + ".m4a"
            let newAudioFileURL = documentsDirectory.appendingPathComponent(newAudioFileName)
            
            do {
                let audioData = try Data(contentsOf: audioURL)
                try audioData.write(to: newAudioFileURL)
                vocab.audioFilePath = newAudioFileURL.path
                print("*******************************************************")
                print("Audio file saved to disk and path stored in Core Data")
                print(vocab.audioFilePath ?? "")
            } catch {
                print("Error saving audio file to disk and storing path in Core Data")
            }
        }
        
        lAppDelegate?.saveContext()
        
        NewVocabTextField.text = ""
        TranslationTextField.text = ""
        DefinitionTextField.text = ""
        
        NewVocabTextField.resignFirstResponder()
        TranslationTextField.resignFirstResponder()
        DefinitionTextField.resignFirstResponder()
        GroupTextField.resignFirstResponder()
    }
    
    @IBAction func clearCoreData(_ sender: Any) {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Vocab.fetchRequest()
        let deleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        do {
            try lVocabContext?.execute(deleteRequest1)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = VocabularyGroup.fetchRequest()
        let deleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        do {
            try lVocabContext?.execute(deleteRequest2)
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
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





