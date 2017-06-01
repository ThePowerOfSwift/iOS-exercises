//
//  ViewController.swift
//  Hello World
//
//  Created by Rob Percival on 16/06/2016.
//  Copyright © 2016 Appfish. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBAction func editingChanged(_ sender: UITextField) {
        if let txt = sender.text, let value = Double(txt) {
            self.updateAgeLabel(value)
        } else {
            self.updateAgeLabel(0)
        }
    }
    @IBAction func onValueChanged(_ sender: UITextField) {
        
    }

    @IBAction func onAgeUpdate(_ sender: UITextField) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.updateAgeLabel(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAgeLabel(_ newAge: Double){
        ageLabel.text = "\(newAge * 7)"
    }
}
