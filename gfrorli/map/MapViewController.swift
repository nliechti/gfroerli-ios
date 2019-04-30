//
//  MapViewController.swift
//  gfrorli
//
//  Created by Niklas Liechti on 02.02.19.
//  Copyright © 2019 Niklas Liechti. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import os

class MapViewController: UIViewController {

    let regionRadius: CLLocationDistance = 35000
    let locationManager = CLLocationManager()
    
    @IBOutlet var mapView: MKMapView!
    var sensors: [Int : Sensor] = [:]
    
//    @IBAction func mapTypeSegmentSelected(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            mapView.mapType = .standard
//        case 1:
//            mapView.mapType = .satellite
//        default:
//            mapView.mapType = .hybrid
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(SensorMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.showsCompass = true
        mapView.showsBuildings = true
        
//        mapView.mapType = .standard;  // default: road map
//        mapView.mapType = .satellite;
        mapView.mapType = .hybrid;
        
        centerMapOnLocation(location: CLLocation(latitude: 47.226015, longitude: 8.734503))
        mapView.delegate = self
        loadSensors()
    }
    
    func loadSensors() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sensors")!)
        request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                guard let data = data else {return}
                
                let jsonDecoder = JSONDecoder()
                let sensors = try jsonDecoder.decode([Sensor].self, from: data)
                sensors.forEach({ (sensor) in
                    self.addNewSensorToMap(sensor: sensor);
                })
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    func addNewSensorToMap(sensor: Sensor) {
        let sensorMapPoint = SensorMarker(sensor: sensor)
        self.mapView.addAnnotation(sensorMapPoint)
        self.updateViewConstraints()
    }

    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                               latitudinalMeters: regionRadius,
                               longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
}
