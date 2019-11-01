//
//  AudioPlaybackViewController.swift
//  Audio Capture and Playback
//
//  Created by Henry Sills on 10/30/19.
//  Copyright © 2019 Henry Sills. All rights reserved.
//

import UIKit
import AVKit

class AudioPlaybackViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    
    @IBOutlet weak var recordButton: UIBarButtonItem!
    @IBOutlet weak var playButton: UIBarButtonItem!
   
    var audioRecorder = AVAudioRecorder()
    var player = AVAudioPlayer()
    let audioSession = AVAudioSession.sharedInstance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.recordButton.isEnabled = true
        //self.playButton.isEnabled = true
        request()
    }

    @IBAction func playPressed(_ sender: UIBarButtonItem) {
            if playButton.image == UIImage(named: "play") {
                player.play()
                playButton.image = UIImage(named: "stop")
                recordButton.isEnabled = false
            } else {
                print("Error: Could not play audio")
                player.stop()
                playButton.image = UIImage(named: "play")
                recordButton.isEnabled = true
               }
        }
        
        @IBAction func recordPressed(_ sender: UIBarButtonItem) {
            if sender.image == UIImage(named: "record") {
            //if audioRecorder == nil {
                    startRecording()
                } else {
                    finishRecording(success: true)
                }
            }
    
    func request() {
        audioSession.requestRecordPermission(){
        [unowned self] allowed in
        if allowed {
            self.recordButton.isEnabled = true
            do {
                try self.audioSession.setCategory(.playAndRecord, mode: .default)
                try self.audioSession.setActive(true)
                //self.recordButton.isEnabled = true
                        
            } catch {
                self.recordButton.isEnabled = false
                print("Could not record audio")
            }
        }else {
            print("Could not record audio")
        }

        // Do any additional setup after loading the view.
        }
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0] as [String : Any]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            self.recordButton.image = UIImage(named: "stop")
            self.playButton.isEnabled = false
            audioRecorder.record()
            
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        //audioRecorder.stop()
        //audioRecorder = nil
        if success {
            self.recordButton.image = UIImage(named: "record")
            self.playButton.isEnabled = true
        } else {
            self.recordButton.image = UIImage(named: "record")
            print("Recording failed. Try again")
        }
    
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }

}
