//
//  locationNotificationHandler.swift
//  iOS
//
//  Created by Marc on 22.02.21.
//

/*import Foundation
import CoreLocation
import UserNotifications


class LocationNotificationHandler {
    
    static let notificationCenter = UNUserNotificationCenter.current()
    
    static func requestNotificationPermission(){
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            #warning("ADD ERROR")
        }
    }
    static func getNotificationPermissionStatus()->UNAuthorizationStatus{
        var status: UNAuthorizationStatus = .notDetermined
        notificationCenter.getNotificationSettings { settings in
            status = settings.authorizationStatus
        }
        return status
        
    }
    
    static func addLocationNotification(for sensor: Sensor){
        
        if self.getNotificationPermissionStatus() == .notDetermined {
            self.requestNotificationPermission()
        }else if self.getNotificationPermissionStatus() == .denied {
            return
        }
        
        if (!LocationHandler.hasAllwaysPermission() || !LocationHandler.hasInUsePermission()) && !LocationHandler.deniedPermission(){
            LocationHandler.requestLocationPermission()
        } else{
            return
        }
        //47.236052, 8.837125
        let center = CLLocationCoordinate2D(latitude: sensor.latitude! , longitude: sensor.longitude!)
        let region = CLCircularRegion(center: center, radius: 200.0, identifier: "Sensor Location")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Welcome at \(sensor.device_name)!"
        content.body = "Tap to see the current temperature!"
        content.userInfo = ["sensorID": "\(sensor.id)"]
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "LocationNotificationSensor\(sensor.id)", content: content, trigger: trigger)
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription)
            #warning("ADD ERROR")
        }
        notificationCenter.getPendingNotificationRequests { reqs in
            print(reqs)
        }
    }
    
    
    static func removePendingLocationNotification(for sensor: Sensor){
        notificationCenter.getPendingNotificationRequests { requests in
            for req in requests{
                if req.identifier == "LocationNotificationSensor\(sensor.id)"{
                    notificationCenter.removePendingNotificationRequests(withIdentifiers: [req.identifier])
                }
            }
        }
    }
    
    
    
    static func testNotification(){
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

        let content = UNMutableNotificationContent()
        content.title = "Welcome at __!"
        content.body = "Tap to see the current temperature!"
        content.userInfo = ["sensorID": "__"]
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "LocationNotificationSensor", content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription)
            #warning("ADD ERROR")
        }
        notificationCenter.getPendingNotificationRequests { reqs in
            print(reqs)
        }
    }
}
*/
