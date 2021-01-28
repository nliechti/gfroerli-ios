//
//  SensorListViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class SensorListViewModel: LoadableObject {
    typealias Output = [Sensor]
    
    @Published var sensorArray = [Sensor]() { didSet { didChange.send(())}}
    @Published private(set) var state = LoadingState<Output>.idle

    let didChange = PassthroughSubject<Void, Never>()
        
    init() {
    }
        
    init(sensors: [Sensor]) {
        sensorArray = sensors
    }
    
    
    
    func load() {
        
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors")!)
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
                    self.state = .loaded(sensors)
                    
                }else {
                    self.state = .failed
                }
                }catch{
                    self.state = .failed
                }
            }
        }.resume()
    }
}




let testSensorVM = SensorListViewModel(sensors: [testSensor])
