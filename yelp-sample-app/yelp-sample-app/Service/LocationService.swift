//
//  LocationService.swift
//  yelp-sample-app
//
//  Created by Colin on 5/19/20.
//  Copyright © 2020 Colin. All rights reserved.
//

import UIKit
import CoreLocation

protocol Locatable {
    func start()
    var currentLocation: CLLocationCoordinate2D? { get }
    var locationUpdate: ((CLLocationCoordinate2D) -> ())?	 { get set }
}

class LocationService: NSObject, Locatable {
    var locationUpdate: ((CLLocationCoordinate2D) -> ())?
    var currentLocation: CLLocationCoordinate2D? {
        get {
            return locationManager.location?.coordinate
        }
    }
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstCoord = locations.first?.coordinate {
            self.locationUpdate?(firstCoord)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}
