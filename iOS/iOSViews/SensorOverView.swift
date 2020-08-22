//
//  SensorOverView.swift
//  iOS
//
//  Created by Marc Kramer on 22.08.20.
//

import SwiftUI

struct SensorOverView: View {
    @State var sensorname: String
    var body: some View {
        Text(sensorname)
    }
}

struct SensorOverView_Previews: PreviewProvider {
    static var previews: some View {
        SensorOverView(sensorname: "owo")
    }
}
