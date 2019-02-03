//
//  MeasurementMarkerView.swift
//  gfrorli
//
//  Created by Niklas Liechti on 03.02.19.
//  Copyright © 2019 Niklas Liechti. All rights reserved.
//

import MapKit

class SensorMarkerView: MKMarkerAnnotationView {

    override var annotation: MKAnnotation? {
        willSet {
            guard let sensorMarker = newValue as? SensorMarker else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = .blue
            if let temperature = sensorMarker.sensor.last_measurement?.temperature {
                let temperatureDouble: Double = (temperature as NSString).doubleValue
                glyphText = String(Double(round(10*temperatureDouble)/10))
            } else {
                glyphText = "?"
            }
        }
    }

}
