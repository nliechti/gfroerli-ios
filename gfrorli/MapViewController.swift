//
//  MapViewController.swift
//  gfrorli
//
//  Created by Niklas Liechti on 02.02.19.
//  Copyright © 2019 Niklas Liechti. All rights reserved.
//

import UIKit
import Mapbox
import Foundation
import os

class MapViewController: UIViewController, MGLMapViewDelegate {

    var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 47.226015, longitude: 8.734503), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        
        loadSensors()
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
//        mapView.addAnnotations(loadSensors())
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func loadSensors() {
        
        var request = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sensors")!)
        request.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            debugPrint(response!)
            do {
                guard let data = data else {return}
                
                let jsonDecoder = JSONDecoder()
                let sensors = try jsonDecoder.decode([Sensor].self, from: data)
                sensors.forEach({ (sensor) in
                    self.addNewSensorToMap(sensor: sensor);
                })
            } catch let error {
                debugPrint(error)
            }
        }).resume()
    }
    
    func addNewSensorToMap(sensor: Sensor) {
        let sensorMapPoint = MGLPointAnnotation()
        sensorMapPoint.coordinate = CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!)
        sensorMapPoint.title = sensor.device_name
        sensorMapPoint.subtitle = sensor.caption
        self.mapView.addAnnotation(sensorMapPoint)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
