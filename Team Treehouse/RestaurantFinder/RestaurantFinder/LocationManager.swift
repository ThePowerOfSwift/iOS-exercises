//
//  LocationManager.swift
//  RestaurantFinder
//
//  Created by Davide Callegari on 06/07/17.
//  Copyright © 2017 Davide Callegari. All rights reserved.
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

enum Message: Hashable {
    case locationFix
    case permissionUpdate
    case locationError
}
typealias Listener = ((Any) -> Void)
typealias Listeners = [Message: [Listener]]

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var listeners: Listeners = [:]
    let authorized: Bool = {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }()
    var started = false

    override init() {
        super.init()
        manager.delegate = self
        manager.distanceFilter = 1000.0 // meters
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func startListeningForLocationChanges() {
        if authorized && !started {
            started = true
            manager.startUpdatingLocation()
        }
    }
    
    func on(_ message: Message, listener: @escaping Listener) {
        if listeners[message] == nil {
            listeners[message] = []
        }
        listeners[message]!.append(listener)
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

        if let permissionUpdateListeners = listeners[.permissionUpdate] {
            for listener in permissionUpdateListeners {
                listener(status)
            }
        }

        if status == .authorizedWhenInUse {
            self.startListeningForLocationChanges()
        } else if status == .denied {
            // notify users that the app won't work
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let locationErrorListeners = listeners[.locationError] else { return }
        for listener in locationErrorListeners {
            listener(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first,
            let locationFixListeners = listeners[.locationFix]
            else { return }
        
        locationFixListeners.forEach { listener in
            DispatchQueue.main.async {
                // TODO check if this is actually fixing it
                listener(Coordinate(location: location))
            }
        }
    }
    
    deinit {
        listeners = [:]
    }
}


struct Pin {
    let title: String
    var latitude: Double
    var longitude: Double
}


final class SimpleMapManager: NSObject, MKMapViewDelegate {
    private let map:MKMapView
    
    var regionRadius: Double
    
    init(_ map: MKMapView, regionRadius: Double?){
        self.map = map
        self.regionRadius = regionRadius ?? 1000.0
        super.init()
        map.delegate = self
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
    
    func removeAllPins(){
        if map.annotations.count == 0 { return }
        map.removeAnnotations(map.annotations)
    }

    // MARK: MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            let button = UIButton(type: .detailDisclosure)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = button
        }
        /*
        MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        */
    }
}

class SimpleAlert {
    private let alert: UIAlertController
    
    static func `default`(title: String, message: String) -> SimpleAlert {
        let alert = SimpleAlert(title: title, message: message)
        return alert
    }
        
    init(title: String, message: String) {
        self.alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
    }
    func show(using viewController: UIViewController) {
        viewController.present(alert, animated: true, completion: nil)
    }
}
