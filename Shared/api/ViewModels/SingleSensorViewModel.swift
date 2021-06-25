//
//  SingleSensorViewModel.swift
//  Gfror.li
//
//  Created by Marc Kramer on 19.09.20.
//

import Foundation
import Combine

class SingleSensorViewModel: LoadableObject {
    typealias Output = Sensor

    @Published var sensor: Sensor! { didSet { didChange.send(())}}
    @Published private(set) var state = LoadingState<Output>.idle

    let didChange = PassthroughSubject<Void, Never>()
    var id: Int = 0

    init() {
        sensor = nil
    }

    init(sensor: Sensor) {
        self.sensor = sensor
    }

    public func load() {
        self.state = .loading
        var url = URLRequest(url: URL(string: "https://watertemp-api.coredump.ch/api/mobile_app/sensors/\(id)")!)
        url.setValue("Bearer XTZA6H0Hg2f02bzVefmVlr8fIJMy2FGCJ0LlDlejj2Pi0i1JvZiL0Ycv1t6JoZzD", forHTTPHeaderField: "Authorization")
        url.httpMethod = "GET"

        URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                do {
                if let data = data {
                    // success: convert to  Sensors
                    let jsonDecoder = JSONDecoder()
                    let sensor = try jsonDecoder.decode(Sensor.self, from: data)
                    self.sensor = sensor
                    self.state = .loaded(sensor)
                } else {
                    // other cases
                    self.state = .failed
                }
                    // decoding failed
                } catch {
                    self.state = .failed
                }
            }
        }.resume()
    }
}
