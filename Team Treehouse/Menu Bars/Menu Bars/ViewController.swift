//
//  ViewController.swift
//  Menu Bars
//
//  Created by Davide Callegari on 22/03/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let timer = EggTimer(interval: 1)
    let defaultTime = 210
    var currentTime = 0 {
        didSet {
            passingSecondsLabel.text = "\(currentTime)"
            
            if currentTime == 0 {
                timer.pause()
                doneLabel.isHidden = false
            } else {
                doneLabel.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var pauseLabel: UILabel!
    @IBOutlet weak var passingSecondsLabel: UILabel!
    @IBOutlet weak var doneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.reset()
        
        timer.onNextTick(){
            self.updateCurrentTimeBy(amount: -1)
        }
    }
    
    @IBAction func onPlay(_ sender: UIBarButtonItem) {
        pauseLabel.isHidden = true
        timer.start()
    }
    
    @IBAction func onPause(_ sender: UIBarButtonItem) {
        pauseLabel.isHidden = false
        timer.pause()
    }

    @IBAction func decreaseTimeByTen(_ sender: UIBarButtonItem) {
        self.updateCurrentTimeBy(amount: -10)
    }
    
    @IBAction func increaseTimeByTen(_ sender: UIBarButtonItem) {
        self.updateCurrentTimeBy(amount: 10)
    }
    
    @IBAction func rewindTimer(_ sender: UIBarButtonItem) {
        self.reset()
    }
    
    func updateCurrentTimeBy(amount: Int){
        var result = currentTime + amount
        
        if(result > defaultTime){
            result = defaultTime
        } else if(result < 0){
            result = 0
        }
        
        currentTime = result
    }
    
    func reset(){
         currentTime = defaultTime
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

typealias Listener = (Void) -> Void

class EggTimer {
    private var internalTimer: Timer?
    private var listeners: [Listener] = []
    var isPaused = true
    
    init(interval: Double){
        internalTimer = Timer.scheduledTimer(
            timeInterval: interval,
            target: self,
            selector: #selector(EggTimer.nextTick),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc func nextTick(){
        if(!isPaused){
            for listener in listeners {
                listener()
            }
        }
    }
    
    func start(){
        isPaused = false
        //internalTimer!.fire()
    }
    
    func pause(){
        isPaused = true
        //internalTimer?.invalidate()
    }
    
    func onNextTick(callback: @escaping Listener){
        listeners.append(callback)
    }
}
