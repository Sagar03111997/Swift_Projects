//
//  VocabTableViewCell.swift
//  VocabLearning
//
//  Created by 庞景文 on 4/13/23.


/*

Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu

Submission date: 4/22

Project Name: VocabLearning
 
 */
//

import UIKit
import AVFoundation

class VocabTableViewCell: UITableViewCell, AVAudioPlayerDelegate{
    
    var audioPlayer: AVAudioPlayer!
    var audioFilePath: String?
    var audioFileName : String = "recording.m4a"

    @IBOutlet weak var VocabNameLabel: UILabel!
    @IBOutlet weak var TranslationLabel: UILabel!
    @IBOutlet weak var DefinitionLabel: UILabel!
    @IBOutlet weak var PlayDataButtom: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func playButtonTapped(_ sender: AudioDataButton) {
        if let audioFilePath = audioFilePath {
            let audioURL = URL(fileURLWithPath: audioFilePath)
            let audioFileName = audioURL.lastPathComponent
            print("Audio file name: \(audioFileName)")
            
            self.audioFileName = audioFileName
            
            setupPlayer()
            
            if let player = audioPlayer {
                player.play()
            } else {
                print("Error: Audio player is nil")
            }

        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
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
    
}



class AudioDataButton: UIButton {
}


