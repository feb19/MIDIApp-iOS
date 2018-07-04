//
//  ViewController.swift
//  MIDIApp
//
//  Created by TakahashiNobuhiro on 2018/07/04.
//  Copyright © 2018 feb19. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let engine = AVAudioEngine()
    let sampler = AVAudioUnitSampler()
    
    // instance variables
    
    let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
    let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
    let gmMarimba = UInt8(12)
    let gmHarpsichord = UInt8(6)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setup() {
        engine.attach(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        loadPatch(gmpatch: gmHarpsichord)
        
        engine.prepare()
        do { try engine.start() } catch { print("error")  }
        
    }
    
    @IBAction func buttonWasTouchedDown(_ sender: Any) {
        self.sampler.startNote(60, withVelocity: 64, onChannel: 0)

    }
    
    @IBAction func buttonWasTouchedUp(_ sender: Any) {
        self.sampler.stopNote(60, onChannel: 0)
    }
    
    
    func loadPatch(gmpatch:UInt8, channel:UInt8 = 0) {
        
        guard let soundbank =
            Bundle.main.url(forResource: "TimGM6mb", withExtension: "sf2")
            else {
                print("could not read sound font")
                return
        }
        
        do {
            try sampler.loadSoundBankInstrument(at: soundbank, program: gmpatch,
                                                     bankMSB: melodicBank, bankLSB: defaultBankLSB)
            
        } catch let error as NSError {
            print("\(error.localizedDescription)")
            return
        }
        
        self.sampler.sendProgramChange(gmpatch, bankMSB: melodicBank, bankLSB: defaultBankLSB, onChannel: channel)
    }

}

