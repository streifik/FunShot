//
//  LocationManage.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 08.11.2023.
//

import Foundation
import CoreLocation

final class HSCFLocation_HS_Mnrg {
    
    let locationManager = CLLocationManager()
    
    var isAsked: Bool { return CLLocationManager.authorizationStatus() != .notDetermined }
    
    var isAllowed: Bool {
        let status = CLLocationManager.authorizationStatus()
        return status != .denied && status != .notDetermined && status != .restricted
    }
    
    var isDenied: Bool {
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    var currentLocation: CLLocation? { return locationManager.location }
    var currentCoordinate: CLLocationCoordinate2D? { return currentLocation?.coordinate }
    var currentLocationAccuracy: CLLocationAccuracy? { return currentLocation?.horizontalAccuracy }
    
    init() {
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager.distanceFilter = 10
                self?.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self?.locationManager.startUpdatingLocation()
            }
        }
    }
    
    convenience init(delegate: CLLocationManagerDelegate) {
        self.init()
        locationManager.delegate = delegate
    }
    
    func askForAccess() {
        if isAsked { return }
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
}
