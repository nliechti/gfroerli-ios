//
//  MeasurementMarker.swift
//  gfrorli
//
//  Created by Niklas Liechti on 03.02.19.
//  Copyright © 2019 Niklas Liechti. All rights reserved.
//

import MapKit

class SensorMarker: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var sensor: Sensor
    var title: String?
    var subtitle: String?
    
    init(sensor: Sensor) {
        self.coordinate = CLLocationCoordinate2D(latitude: sensor.latitude!, longitude: sensor.longitude!)
        self.sensor = sensor
        self.title = sensor.device_name!
        self.subtitle = sensor.caption!
    }
}
