//
//  ViewController.swift
//  Test1234
//
//  Created by Davide Callegari on 19/04/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let sampleView = UIView()
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setConstraints()
    }
    
    func setConstraints(){
        let topLayoutGuide = UILayoutGuide()
        let centerLayoutGuide = UILayoutGuide()
        let bottomLayoutGuide = UILayoutGuide()
        
        view.addLayoutGuide(topLayoutGuide)
        view.addLayoutGuide(centerLayoutGuide)
        view.addLayoutGuide(bottomLayoutGuide)
        
        let firstViewToTopGuideConstraint = NSLayoutConstraint(item: firstView, attribute: .bottom, relatedBy: .equal, toItem: topLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let secondViewToTopGuideConstraint = NSLayoutConstraint(item: secondView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let secondViewToBottomGuideConstraint = NSLayoutConstraint(item: secondView, attribute: .bottom, relatedBy: .equal, toItem: centerLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let thirdViewToCenterGuideConstraint = NSLayoutConstraint(item: thirdView, attribute: .top, relatedBy: .equal, toItem: centerLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let thirdViewToBottomGuideConstraint = NSLayoutConstraint(item: thirdView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        let fourthViewToBottomGuideConstraint = NSLayoutConstraint(item: fourthView, attribute: .top, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        let topGuideHeightConstraint = NSLayoutConstraint(item: topLayoutGuide, attribute: .height, relatedBy: .equal, toItem: centerLayoutGuide, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        let centerGuideHeightConstraint = NSLayoutConstraint(item: centerLayoutGuide, attribute: .height, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .height, multiplier: 1.0, constant: 0.0)
        
        view.addConstraints([firstViewToTopGuideConstraint, secondViewToTopGuideConstraint, secondViewToBottomGuideConstraint, thirdViewToCenterGuideConstraint, thirdViewToBottomGuideConstraint, fourthViewToBottomGuideConstraint, topGuideHeightConstraint, centerGuideHeightConstraint])
        
        //NSLayoutConstraint.activate()
    }
}
