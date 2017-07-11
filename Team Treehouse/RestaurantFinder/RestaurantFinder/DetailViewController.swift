//
//  DetailViewController.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/4/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import MapKit


class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var map: MKMapView!

    var venue: Venue? {
        didSet {
            self.configureView()
        }
    }

    private func configureView() {
        // Update the user interface for the detail item.
        updateLabel()
        updateMap()
    }
    
    private func updateLabel(){
        guard let venue = self.venue, let label = self.detailDescriptionLabel else { return }
        label.text = venue.name
    }
    
    private func updateMap(){
        guard let venue = self.venue,
            let latitude = venue.location?.coordinate?.latitude,
            let longitude = venue.location?.coordinate?.longitude
            else { return }

        let mapManager = SimpleMapManager(map, regionRadius: 200.0)
        mapManager.showRegion(latitude: latitude, longitude: longitude)
        mapManager.addPin(title: venue.name, latitude: latitude, longitude: longitude)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.venue = nil
    }
}
