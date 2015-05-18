//
//  CoreLocationController.swift
//  Stormy
//
//  Created by Ryan Walker on 5/10/15.
//  Copyright (c) 2015 Witt Labs, LLC. All rights reserved.
//

import Foundation
import CoreLocation

class CoreLocationController: NSObject, CLLocationManagerDelegate {
    var aLocationManager: CLLocationManager = CLLocationManager()
    var locationString: String?
    
    override init() {
        super.init()
        self.aLocationManager.delegate = self
        self.aLocationManager.distanceFilter = 3000
        self.aLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.aLocationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("The App did change authorization status to:")
        
        switch status {
        case .NotDetermined:
            println(".NotDetermined")
            self.aLocationManager.requestAlwaysAuthorization()
            break
            
        case .AuthorizedAlways:
            println(".AuthorizedAlways")
            self.aLocationManager.startUpdatingLocation()
            break
            
        case .AuthorizedWhenInUse:
            println(".AuthorizedWhenInUse")
            self.aLocationManager.startUpdatingLocation()
            break
        
        case .Denied:
            println(".Denied")
            break
            
        case .Restricted:
            println(".Restricted")
            break
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        let location = locations.last as! CLLocation
        
        locationString = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
        
        println("didUpdateLocations: \(locationString)")
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("location could not be retrieved with \(error)")
    }
    
    func
    
    func returnLocation() -> String {
        return locationString!
    }

}
