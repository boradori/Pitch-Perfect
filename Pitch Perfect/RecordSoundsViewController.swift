//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Youngsun Paik on 1/19/16.
//  Copyright © 2016 Youngsun Paik. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio! // in order to use a different class
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        pauseButton.hidden = true
        recordButton.enabled = true
        recordLabel.text = "Tap to Record"
        recordLabel.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        print("in recordAudio")
        recordLabel.hidden = false
        stopButton.hidden = false
        pauseButton.hidden = false
        recordButton.enabled = false
        
        recordLabel.text = "Recording in progress"
        
        // dirPath defines where to save file as a string
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        // filePath is pathArray converted in NSURL
        // NSURL.fileURLWithPathComponents returns string as NSURL
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        
        // AVAudioRecorder is there to track one indivisual recording
        // AVAudioSession is there to enable and track sound recording as a whole
        let session = AVAudioSession.sharedInstance() //sharedInstance => Returns the singleton audio session
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        // need AVAudioRecorderDelegate to be able to use audioRecorderDidFinishRecording function
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        // prepareToRecord creates an audio file and prepares the system for recording.
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func pauseAudio(sender: UIButton) {
        // http://stackoverflow.com/questions/29004182/how-to-change-uibutton-image-after-clicking-in-swift got information about changing image from this stackoverflow page
        let resumeImage = UIImage(named:"Resume") as UIImage!
        let pauseImage = UIImage(named:"Pause") as UIImage!
        if (pauseButton.currentImage == pauseImage) {
            audioRecorder.pause()
            pauseButton.setImage(resumeImage, forState: .Normal)
            recordLabel.text = "Recording paused"
        } else {
            audioRecorder.record()
            pauseButton.setImage(pauseImage, forState: .Normal)
            recordLabel.text = "Recording in progress"
        }
    }
    
    // This code runs when the audio finishes recording
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            // Save audio in model
            // recorder is the first argument of the function
            // lastPathComponent gives name of the file
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            // perform segue
            // stopRecording will be used for conditional statement
            // sender sends recordedAudio through the segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording failed...")
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            recordLabel.text = "Recording failed"
        }
    }
    
    // This gets called just before a segue is about to be performed
    // Therefore, this is a great place to pass any data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            // destinationViewController contains the view controller whose contents should be displayed at the end of the segue.
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio // need to pass this data to playVC but it doesn't have a way of receiving data so we need the next line.
            playSoundsVC.receivedAudio = data // receivedAudio is what PlayViewController gets from the model
        }
        
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        recordLabel.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}

