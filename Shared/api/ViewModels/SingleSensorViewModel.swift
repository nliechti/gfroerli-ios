//
//  SingleSensorViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class SingleSensorViewModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var sensor = Sensor(id: nil, device_name: nil, caption: nil, latitude: nil, longitude: nil, sponsor_id: nil, measurement_ids: nil, created_at: nil, updated_at: nil, last_measurement: nil, url: nil) { didSet { didChange.send(())}}
    
    init() {
    }
    
    init(sensor: Sensor) {
        self.sensor = sensor
    }
    
    
    func getAllSensors(id: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        #warning("implement id into URL when api available")
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/sensors")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Sensors
                    let jsonDecoder = JSONDecoder()
                    let sensor = try jsonDecoder.decode(Sensor.self, from: data)
                    self.sensor = sensor
                    completion(.success("Sensor successfuly loaded!"))
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
