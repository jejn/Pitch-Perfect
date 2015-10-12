//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jim Nording on 18/09/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "Recording..."
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
        
        // Define where recording will be stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // Name and store recording
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        // Initialize Audio Session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        // Setup and start recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        }
    
    @IBAction func pauseRecording(sender: UIButton) {
        audioRecorder.pause()
        pauseButton.hidden = true
        resumeButton.hidden = false
        recordingLabel.text = "Paused"
    }
    
    @IBAction func resumeRecording(sender: UIButton) {
        audioRecorder.record()
        resumeButton.hidden = true
        pauseButton.hidden = false
        recordingLabel.text = "Recording..."
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully: Bool) {
        if successfully {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
}