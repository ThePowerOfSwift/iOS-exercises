//
//  LocationManager.swift
//  RestaurantFinder
//
//  Created by Davide Callegari on 06/07/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension Coordinate {
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
}

typealias Listener = ((Coordinate) -> Void)

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var listeners: [Listener] = []
    let authorized = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    var started = false
    
    override init() {
        super.init()
        manager.delegate = self
        manager.distanceFilter = 100.0 // meters
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func startListeningForLocationChanges() {
        if authorized && !started {
            started = true
            manager.startUpdatingLocation()
        }
    }
    
    func onLocationFix(_ listener: @escaping Listener) {
        listeners.append(listener)
    }
    
    func getPermission(){
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if authorized {
            return
        }
        
        if status == .authorizedWhenInUse {
            self.startListeningForLocationChanges()
        } else if status == .denied {
            // notify users that the app won't work
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // inform user that an error happened
        print("AAAAAAAAAAAAA: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first  else { return }
        
        
        listeners.forEach { listener in
            DispatchQueue.main.async {
                // TODO check if this is actually fixing it
                listener(Coordinate(location: location))
            }
        }
    }
    
    deinit {
        listeners = []
    }
}


struct Pin {
    let title: String
    var latitude: Double
    var longitude: Double
}


final class SimpleMapManager {
    private let map:MKMapView
    var regionRadius: Double
    
    init(_ map: MKMapView, regionRadius: Double){
        self.map = map
        self.regionRadius = regionRadius
    }
    
    func showRegion(latitude: Double, longitude: Double){
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        let region = MKCoordinateRegionMakeWithDistance(location, regionRadius * 2, regionRadius * 2)
        map.setRegion(region, animated: true)
    }
    
    func addPin(title: String, latitude: Double, longitude: Double){
        let pin = MKPointAnnotation()
        pin.title = title
        pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        map.addAnnotation(pin)
    }
    
    func addPins(pinsData: [Pin]){
        for pinData in pinsData {
            addPin(title: pinData.title, latitude: pinData.latitude, longitude: pinData.longitude)
        }
    }
}
