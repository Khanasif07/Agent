//
//  LocationController.swift
//  ArabianTyres
//
//  Created by Admin on 15/09/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

let SharedLocationManager = LocationController.sharedLocationManager

class LocationController : NSObject, CLLocationManagerDelegate {
    
    static let sharedLocationManager = LocationController()
    
    fileprivate var locationUpdateCompletion : ((CLLocation)->Void)?
    
    let locationManager = CLLocationManager()
    
    private var isStartLocationUpdate: Bool = false
    
    var currentLocation : CLLocation?
    
    let regionMonitoringIndentifier = "regionMonitoring_\(NSUUID().uuidString.replacingOccurrences(of: "-", with: ""))"
    
    var regionRadius : Double = 200.0
    
    var locationsEnabled : Bool {
        
        if( CLLocationManager.locationServicesEnabled() &&
            CLLocationManager.authorizationStatus() != CLAuthorizationStatus.denied) {
            
            return true
            
        } else {
            
            return false
        }
    }
    
    override init() {
        
        super.init()
        
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        //        locationManager.allowsBackgroundLocationUpdates = true
        //        locationManager.distanceFilter = 30.0
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func fetchCurrentLocation(_ completion : @escaping (CLLocation)->Void){
        
        self.locationUpdateCompletion = completion
        getCurrentLocation()
        
    }
    
    fileprivate func getCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
            
        case .authorizedAlways,.authorizedWhenInUse:
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    //MARK:-Geo fencing
    func monitorBackgroundLocation() {
        
        if let tempLocation = currentLocation{
            
            let region = CLCircularRegion(center: tempLocation.coordinate, radius: regionRadius, identifier: regionMonitoringIndentifier)
            setRegionRadius(location: tempLocation)
            region.notifyOnExit = true
            startMonitoring(geoRegion: region)
        }
    }
    
    func startMonitoring(geoRegion: CLCircularRegion) {
        
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) { return }
        
        locationManager.startMonitoring(for: geoRegion)
    }
    
    func stopMonitoringGeoRegions() {
        
        for region in locationManager.monitoredRegions {
            
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == regionMonitoringIndentifier else { continue }
            
            locationManager.stopMonitoring(for: circularRegion)
            
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        if region is CLCircularRegion {
            
            if UIApplication.shared.applicationState != .active {
                monitorBackgroundLocation()
            }else{
                stopMonitoringGeoRegions()
            }
            
            locationManager.startUpdatingLocation()
        }
    }
    
    func setRegionRadius(location: CLLocation) {
        
        regionRadius = 200
        
        if location.speed > 15 && location.speed <= 20{
            
            regionRadius = 250
            
        }else if location.speed > 20 && location.speed <= 25{
            
            regionRadius = 350
            
        }else if location.speed > 25 && location.speed <= 30{
            
            regionRadius = 500
            
        }else if location.speed > 30{
            
            regionRadius = 1000
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        printDebug(error.localizedDescription)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.stopUpdatingLocation()
            self.locationManager.startUpdatingLocation()
        default:
            self.locationManager.requestAlwaysAuthorization()
        }
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let lastLocation = locations.last {
            self.currentLocation = lastLocation
            if let _ = self.locationUpdateCompletion {
                self.locationUpdateCompletion?(locations.last!)
            }
        }
    }
}
