//
//  SensorOverviewLastMeasurementView.swift
//  iOS
//
//  Created by Marc Kramer on 11.09.20.
//

import SwiftUI

struct SensorOverviewLastMeasurementView: View {
    @ObservedObject var VM: SingleSensorViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if VM.loadingState == .loaded {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading) {
                        Text("Latest")
                            .font(.title)
                            .bold()
                        Text(makeTemperatureString(double: VM.sensor!.latestTemp!))
                            .font(.system(size: 50))
                        Spacer()
                    }.layoutPriority(1)
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("All time:")
                            .font(.title2)
                            .bold()
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Highest:")
                                Text("Average:")
                                Text("Lowest:")
                                
                            }
                            VStack(alignment: .trailing) {
                                Text(makeTemperatureStringFromDouble(double: VM.sensor!.maxTemp!))
                                Text(makeTemperatureStringFromDouble(double: VM.sensor!.avgTemp!))
                                Text(makeTemperatureStringFromDouble(double: VM.sensor!.minTemp!))
                            }
                        }
                    }
                }
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                Text(VM.sensor!.lastTempTime!, format: .relative(presentation: .named))
                
            } else {
                Text("Latest")
                    .font(.title)
                    .bold()
                LoadingView()
            }
            
        }.padding()
        
    }
}

struct SensorOverviewLastMeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
