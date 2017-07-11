//
//  MasterViewController.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/4/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import MapKit

let DEFAULT_COORDINATE = Coordinate(latitude: 40.759106, longitude: -73.985185)

class RestaurantListController: UITableViewController, UISearchBarDelegate {
    let foursquareClient = FoursquareClient(clientID: "5O53IDZJAWB12DFHH1WFEYL2I1I3L0BTYQPHZUGJZYFL5IO4", clientSecret: "DXVEG1PDN0NMSOOZRRLJTWXTAON4RUL3GJSXAZVVEKHP40A3")
    let locationManager = LocationManager()
    var lastReceivedCoordinate: Coordinate = DEFAULT_COORDINATE
    @IBOutlet weak var map: MKMapView!
    
    var venues: [Venue] = [] {
        didSet {
            tableView.reloadData()
            addMapAnnotations()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.getPermission()
        //var firstCall = true
        
        locationManager.onLocationFix { [weak self] coordinate in
            self?.lastReceivedCoordinate = coordinate
            
            // not very user friendly but nice to see and to debug
            //if firstCall == true {
            self?.updateRestaurants(withCoordinate: coordinate, query: nil)
                //firstCall = false
            //}
        }
        
        locationManager.startListeningForLocationChanges()
        
        //updateRestaurants(withCoordinate: defaultCoordinate)
    }
    
    private func updateRestaurants(withCoordinate coordinate: Coordinate, query: String?){
        refreshControl?.beginRefreshing()
        
        foursquareClient.fetchRestaurantsFor(
            coordinate,
            category: .food(nil),
            query: query
            //searchRadius: ,
            //limit: ,
        ) { result in
            switch result {
            case .success(let venues):
                self.venues = venues
            case .failure(let error):
                print(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                
                let venue = venues[indexPath.row]
                controller.venue = venue
                
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let venue = venues[indexPath.row]
        
        cell.setup(title: venue.name, checkinCount: venue.checkins.description, category: venue.categoryName)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBAction func refreshRestaurantData(_ sender: AnyObject) {
        self.updateRestaurants(withCoordinate: lastReceivedCoordinate, query: nil)
    }
    
    func addMapAnnotations(){
        guard let map = map else { return }
        
        let pins: [Pin] = venues.filter { venue in
            return venue.location?.coordinate != nil
        }.map { venue in
            let coordinate = (venue.location?.coordinate)!
            return Pin(
                title: venue.name,
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
        let mapManager = SimpleMapManager(map, regionRadius: 1000)
        mapManager.addPins(pinsData: pins)
        mapManager.showRegion(latitude: lastReceivedCoordinate.latitude, longitude: lastReceivedCoordinate.longitude)
    }
    
    // MARK : UIBarPositioningDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("BBBBBBBBB \(searchText)")
        //updateRestaurants(withCoordinate: lastReceivedCoordinate, query: searchText)
    }
}
