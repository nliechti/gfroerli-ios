//
//  SensorListViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class SensorListViewModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var sensorArray = [Sensor]() { didSet { didChange.send(())}}
    
    init() {
    }
    
    init(sensors: [Sensor]) {
        sensorArray = sensors
    }
    
    
    
    func getAllSensors(completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sensors")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Sensors
                    let jsonDecoder = JSONDecoder()
                    let sensors = try jsonDecoder.decode([Sensor].self, from: data)
                    self.sensorArray = sensors
                    completion(.success("Sensors successfuly loaded!"))
                } else if error != nil {
                    // network failures
                    completion(.failure(.requestFailed))
                } else {
                    // other cases
                    completion(.failure(.unknown))
                }
                    // decoding failed
                }catch{
                    completion(.failure(.decodeFailed))
                }
            }
        }.resume()
    }
}




let testSensorVM = SensorListViewModel(sensors: [testSensor])
