////
////  AudioRecorder.swift
////  VocabLearning
////
////  Created by Mikel  Frausto on 4/22/23.
//
//
///*
//
//Mikel Frausto, fraustom@iu.edu, Jingwen Pang, pangjing@iu.edu
//
//Submission date: 4/22
//
//Project Name: VocabLearning
//
// */
////
//
//import Foundation
//import AVFoundation
//import CoreData
//import UIKit
//import CoreData
//
//class AudioRecorder {
//    var audioRecorder: AVAudioRecorder?
//    var audioPlayer: AVAudioPlayer?
//    var audioFileURL: URL?
//
//    func startRecording() {
//        do{
//            let audioSession = AVAudioSession.sharedInstance()
//
//            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
//            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//
//
//            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let fileName = "myaudio.wav"
//            audioFileURL = documentsDirectory.appendingPathComponent(fileName)
//
//            let settings = [
//                AVFormatIDKey: Int(kAudioFormatLinearPCM),
//                AVSampleRateKey: 44100,
//                AVNumberOfChannelsKey: 1,
//                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//            ]
//            audioRecorder = try AVAudioRecorder(url: audioFileURL!, settings: settings)
//            audioRecorder?.record()
//        }catch{
//            print("we have an error")
//        }
//
//    }
//
//    func stopRecording() {
//        audioRecorder?.stop()
//        saveRecordingToCoreData()
//    }
//
//    func playRecording() {
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOf: audioFileURL!)
//            audioPlayer?.play()
//        } catch {
//            print("Error playing recording: \(error.localizedDescription)")
//        }
//    }
//
//    func saveRecordingToCoreData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let context = appDelegate.persistentContainer.viewContext
//        let recording = Recording(context: context)
//        recording.recordingData = try? Data(contentsOf: audioFileURL!)
//
//        do {
//            try context.save()
//            print("Recording saved to Core Data")
//        } catch {
//            print("Error saving recording to Core Data")
//        }
//    }
//
//    }
