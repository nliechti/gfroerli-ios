//
//  IntentHandler.swift
//  SelectSensorIntentExtension
//
//  Created by Marc on 25.03.21.
//

import Intents

class IntentHandler: INExtension,SingleSensorWithGraphIntentHandling,SingleSensorIntentHandling{
    
    let sensorVM = SensorListViewModel()

    func provideSensorOptionsCollection(for intent: SingleSensorIntent, with completion: @escaping (INObjectCollection<SelectableSensor>?, Error?) -> Void) {
        sensorVM.load()
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            let selectableSensors: [SelectableSensor] = self.sensorVM.sensorArray.map { sensor -> SelectableSensor in
                let selectableSensor = SelectableSensor(
                    identifier: String(sensor.id),
                    display: sensor.device_name
                )
                return selectableSensor
            }

            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: selectableSensors)

            // Call the completion handler, passing the collection.
            completion(collection, nil)
        }
    }
    
    func provideSensorOptionsCollection(for intent: SingleSensorWithGraphIntent, with completion: @escaping (INObjectCollection<SelectableSensor>?, Error?) -> Void) {
        sensorVM.load()
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {

            let selectableSensors: [SelectableSensor] = self.sensorVM.sensorArray.map { sensor -> SelectableSensor in
                let selectableSensor = SelectableSensor(
                    identifier: String(sensor.id),
                    display: sensor.device_name
                )
                return selectableSensor
            }

            // Create a collection with the array of characters.
            let collection = INObjectCollection(items: selectableSensors)

            // Call the completion handler, passing the collection.
            completion(collection, nil)
        }
        
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}