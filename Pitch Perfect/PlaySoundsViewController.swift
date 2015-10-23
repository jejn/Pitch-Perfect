//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jim Nording on 03/10/15.
//  Copyright © 2015 Jim Nording. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer: AVAudioPlayer!
    var echoPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            // Play audio through speakers
            let session = AVAudioSession.sharedInstance()
            try! session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            // Initialize AudioPlayer and Engine
            audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: nil)
            audioPlayer.enableRate = true
            audioEngine = AVAudioEngine()
            audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        } catch {
            print("There was an error with audio")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareAudio(){
        // Stops and resets audioPlayer and audioEngine for new effect
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func setupAndPlay(effect: NSObject){
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect as! AVAudioNode)
        
        audioEngine.connect(audioPlayerNode, to: effect as! AVAudioNode, format: nil)
        audioEngine.connect(effect as! AVAudioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableSpeed(rate: Float){
        prepareAudio()
        
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        prepareAudio()
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        setupAndPlay(changePitchEffect)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariableSpeed(0.5)
        
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariableSpeed(2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)

    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        prepareAudio()
        
        let echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.7
        
        setupAndPlay(echoEffect)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        prepareAudio()
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 50
        
        setupAndPlay(reverbEffect)
    }
    
    @IBAction func stopSound(sender: UIButton) {
        prepareAudio()
    }

}