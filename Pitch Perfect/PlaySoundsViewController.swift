//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Youngsun Paik on 1/21/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioFile:AVAudioFile! // This is to convert NSURL to AVAudioFile and check viewDidLoad
    
    var audioEngine:AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathURL)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithVariableRate(rate: Float) {
        stopAudioPlayerEngine()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableRate(0.5)  // 1 is default
        // currentTime sets the playback point
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableRate(2.0)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAudioPlayerEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // Node is connected to the Effect
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // Effect is connected to the speaker (output)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // Audio File is added to the player node
        // Engine is started to start processing
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func stopAudioPlayerEngine() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudioPlayerEngine()
    }


}
