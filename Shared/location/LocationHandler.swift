//
//  LocationHandler.swift
//  iOS
//
//  Created by Marc on 22.02.21.
//
/*
import Foundation
import CoreLocation

class LocationHandler{
    
    static let locationManager = CLLocationManager()
    
    static func requestLocationPermission(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    static func hasAllwaysPermission()->Bool{
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedAlways{
               return true
            }
        }
        return false
    }
    
    static func hasInUsePermission()->Bool{
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
               return true
            }
        }
        return false
    }
    
    static func deniedPermission()->Bool{
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .denied{
               return true
            }
        }
        return false
    }
}
*/
