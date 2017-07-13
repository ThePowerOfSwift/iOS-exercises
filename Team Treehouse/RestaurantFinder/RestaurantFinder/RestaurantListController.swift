//
//  MasterViewController.swift
//  RestaurantFinder
//
//  Created by Pasan Premaratne on 5/4/16.
//  Copyright © 2017 Davide Callegar. All rights reserved.
//

import UIKit
import MapKit

let DEFAULT_COORDINATE = Coordinate(latitude: 40.759106, longitude: -73.985185)

class RestaurantListController: UITableViewController, UISearchBarDelegate {
    let foursquareClient = FoursquareClient(
        clientID: "5O53IDZJAWB12DFHH1WFEYL2I1I3L0BTYQPHZUGJZYFL5IO4",
        clientSecret: "DXVEG1PDN0NMSOOZRRLJTWXTAON4RUL3GJSXAZVVEKHP40A3"
    )
    let locationManager = LocationManager()
    var lastReceivedCoordinate: Coordinate = DEFAULT_COORDINATE
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var venues: [Venue] = [] {
        didSet {
            tableView.reloadData()
            addMapAnnotations()
        }
    }
    var mapManager: SimpleMapManager? {
        guard let map = map else { return nil }
        return SimpleMapManager(map, regionRadius: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocationManager()
    }

    private func setupLocationManager(){
        locationManager.on(.locationFix) { [weak self] coordinate in
            self?.lastReceivedCoordinate = coordinate as! Coordinate
            self?.updateRestaurants(withCoordinate: coordinate as! Coordinate, query: nil)
        }
        locationManager.on(.locationError) { [weak self] error in
            guard let uiViewController = self else { return }
            let intError = error as! Error

            SimpleAlert.default(
                title: "Localization Error",
                message: intError.localizedDescription
                ).show(using: uiViewController)
        }
        locationManager.on(.permissionUpdate) { [weak self] status in
            let intStatus = status as! CLAuthorizationStatus
            guard let uiViewController = self else { return }

            if intStatus == .denied {
                SimpleAlert.default(
                    title: "Localization Permission Required",
                    message: "Without the permission to use your localization services, this app won't work"
                    ).show(using: uiViewController)
            }
        }
        locationManager.getPermission()
        locationManager.startListeningForLocationChanges()
    }
    
    private func updateRestaurants(withCoordinate coordinate: Coordinate, query: String?){
        refreshControl?.beginRefreshing()
        
        foursquareClient.fetchRestaurantsFor(
            coordinate,
            category: .food(nil),
            query: query ?? searchBar.text
            //searchRadius: ,
            //limit: ,
        ) { result in
            switch result {
            case .success(let venues):
                self.venues = venues
            case .failure(let error):
                SimpleAlert.default(
                    title: "Error retrieving restaurant data",
                    message: error.localizedDescription
                ).show(using: self)
            }
            self.refreshControl?.endRefreshing()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
        guard let mapManager = mapManager else { return }
        
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
        mapManager.removeAllPins()
        mapManager.addPins(pinsData: pins)
        mapManager.showRegion(
            latitude: lastReceivedCoordinate.latitude,
            longitude: lastReceivedCoordinate.longitude
        )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchBar.resignFirstResponder()
            updateRestaurants(withCoordinate: lastReceivedCoordinate, query: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        updateRestaurants(withCoordinate: lastReceivedCoordinate, query: nil)
    }
}
