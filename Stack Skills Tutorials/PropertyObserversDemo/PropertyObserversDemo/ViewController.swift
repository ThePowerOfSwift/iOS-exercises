//
//  ViewController.swift
//  PropertyObserversDemo
//
//  Created by Pasan Premaratne on 1/28/16.
//  Copyright © 2016 Pasan Premaratne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempView: UIView!
    let someString: String
    
    init(testString: String) {
        someString = testString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        someString = ""
        super.init(coder: aDecoder)
    }
    
    var value: Double = 0.0 {
        willSet { aaa() }
        didSet {
            tempView.alpha = CGFloat(value)
            print("New value: \(value)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func aaa(){
        print("Old value: \(value)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slide(_ sender: UISlider) {
        value = Double(sender.value)
    }

}

