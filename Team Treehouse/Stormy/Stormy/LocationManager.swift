//
//  LocationManager.swift
//  Stormy
//
//  Created by Davide Callegari on 04/05/17.
//  Copyright © 2017 Treehouse. All rights reserved.
//

import Foundation
import CoreLocation


private let wrappedManager = CLLocationManager()
typealias OnLocationFixCallback = ((Coordinate) -> Void)


final class LocationManager : NSObject, CLLocationManagerDelegate {
    private var onLocationFix: OnLocationFixCallback?
    static let defaultCoordinates = Coordinate(latitude: 47.1510875, longitude: 8.7021531)
    
    override init(){
        super.init()
        
        wrappedManager.delegate = self
        wrappedManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func getPermission(){
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            print("not authorized, can't do :(")
        case .notDetermined:
            wrappedManager.requestWhenInUseAuthorization()
        default: break
        }
    }
    
    func getCurrentCoordinates(callback: @escaping OnLocationFixCallback) {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            callback(LocationManager.defaultCoordinates)
            return
        }
        
        onLocationFix = callback
        wrappedManager.requestLocation()
    }
    
    // MARK: location manager delegate methods
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("nay!")
        case .authorizedWhenInUse:
            manager.requestLocation()
        default: break // TODO
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) -> Void {
        guard let location = locations.first else {
            return
        }
        
        if let callback = onLocationFix {
            callback(Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
    }
}
