//
//  ViewController.swift
//  AutoLayoutExample7
//
//  Created by Davide Callegari on 20/04/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let orangeView = UIView()
    let blueView = UIView()
    let purpleView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        orangeView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        blueView.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        purpleView.backgroundColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
        
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        purpleView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orangeView)
        view.addSubview(blueView)
        view.addSubview(purpleView)
        
        let views : [String: Any] = [
            "orangeView": orangeView,
            "purpleView": purpleView,
            "blueView": blueView,
            "topLayoutGuide": self.topLayoutGuide
        ]
        let metrics : [String: Any] = [
            "orangeViewWidth": 200,
            "orangeViewHeight": 57,
            "standardOffset": 8,
            "bottomSpaceOffset": 50
        ]
        
        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[orangeView(orangeViewWidth)]",
            options: [],
            metrics: metrics,
            views: views
        )
        orangeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let additionalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-standardOffset-[purpleView]-standardOffset-[orangeView(orangeViewHeight)]-bottomSpaceOffset-|",
            options: [],
            metrics: metrics,
            views: views
        )
        
        let constraints3 = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[topLayoutGuide]-standardOffset-[blueView]-standardOffset-[orangeView]",
            options: [],
            metrics: metrics,
            views: views
        )
        let constraints4 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-standardOffset-[purpleView(==blueView)]-standardOffset-[blueView]-standardOffset-|",
            options: [],
            metrics: metrics,
            views: views
        )
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate(additionalConstraints)
        NSLayoutConstraint.activate(constraints3)
        NSLayoutConstraint.activate(constraints4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
