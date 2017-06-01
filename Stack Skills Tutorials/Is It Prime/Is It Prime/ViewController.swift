//
//  ViewController.swift
//  Is It Prime
//
//  Created by Davide Callegari on 21/03/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func isItPrime(_ sender: UIButton) {
        if let valueAsString = textField.text,
            let value = Int(valueAsString) {
            if self.isItPrime(value) {
                textField.backgroundColor = .green
            } else {
                textField.backgroundColor = .red
            }
        }
    }
    
    private func isItPrime(_ number: Int) -> Bool {
        return number > 1 && !(2..<number).contains { number % $0 == 0 }
    }
}
