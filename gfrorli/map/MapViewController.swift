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
    
    @IBOutlet var mapView: MKMapView!
    var sensors: [Int : Sensor] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(SensorMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        centerMapOnLocation(location: CLLocation(latitude: 47.226015, longitude: 8.734503))
        mapView.delegate = self
        loadSensors()
    }
    
    func loadSensors() {
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
//        if let lastMeasurement = sensor.last_measurement {
//            let sensorSubtitle = """
//            \(sensor.caption!): Letzte Messung \(lastMeasurement.temperature!) C
//            """
//            sensorMapPoint.subtitle = sensorSubtitle
//        } else {
//            sensorMapPoint.subtitle = sensor.caption
//        }
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                               latitudinalMeters: regionRadius,
                               longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? SensorMarker else { return nil }
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
}
