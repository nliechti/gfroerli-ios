//
//  SensorNotificationView.swift
//  iOS
//
//  Created by Marc on 22.02.21.
//

import Foundation
import SwiftUI
import UserNotifications

struct SensorNotificationView: View {
    var sensor: Sensor
    @State var locationToggle = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Location-based")) {
                    Toggle("When arriving at location", isOn: $locationToggle)
                }
                Section(header: Text("Temperature-based")) {
                    Text("todo")
                }
                .onChange(of: locationToggle) { _ in
                   /* if newValue == true{
                        LocationNotificationHandler.addLocationNotification(for: sensor)
                    }else{
                        LocationNotificationHandler.removePendingLocationNotification(for: sensor)
                    }*/
                }
            }.navigationBarTitle("Notifications for \(sensor.device_name)", displayMode: .inline)
        }.onAppear(perform: hasPendingLocationNotification)
    }

    func hasPendingLocationNotification() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            for req in requests {
                print(req.identifier)
                if req.identifier == "LocationNotificationSensor\(sensor.id)"{
                    locationToggle = true

                }
            }
        }
    }
}
