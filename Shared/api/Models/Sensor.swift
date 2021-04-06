/*
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation

struct Sensor: Codable, Identifiable {
    init(id: Int, device_name: String, caption: String?, latitude: Double?, longitude: Double?, sponsor_id: Int?, createdAt: Date?, latestTemp: Double?, maxTemp: Double?, minTemp:Double?,avgTemp:Double?,lastTempTime: Date?) {
        self.id = id
        self.device_name = device_name
        self.caption = caption
        self.latitude = latitude
        self.longitude = longitude
        self.sponsor_id = sponsor_id
        self.createdAt = createdAt
        self.latestTemp = latestTemp
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
        self.lastTempTime = lastTempTime
    }
    
    let id : Int
    let device_name : String
    let caption : String?
    let latitude : Double?
    let longitude : Double?
    let sponsor_id : Int?
    let createdAt : Date?
    let latestTemp : Double?
    let maxTemp: Double?
    let minTemp: Double?
    let avgTemp: Double?
    let lastTempTime: Date?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case device_name = "device_name"
        case caption = "caption"
        case latitude = "latitude"
        case longitude = "longitude"
        case sponsor_id = "sponsor_id"
        case createdAt = "created_at"
        case latestTemp = "latest_temperature"
        case maxTemp = "maximum_temperature"
        case minTemp = "minimum_temperature"
        case avgTemp = "average_temperature"
        case lastTempTime = "latest_measurement_at"
        
    }

   
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        device_name = try values.decode(String.self, forKey: .device_name)
        caption = try values.decodeIfPresent(String.self, forKey: .caption)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
        sponsor_id = try values.decodeIfPresent(Int.self, forKey: .sponsor_id)
        latestTemp = try values.decodeIfPresent(Double.self, forKey: .latestTemp)
        minTemp = try values.decodeIfPresent(Double.self, forKey: .minTemp)
        maxTemp = try values.decodeIfPresent(Double.self, forKey: .maxTemp)
        avgTemp = try values.decodeIfPresent(Double.self, forKey: .avgTemp)
        var createdUNIXStamp = try values.decodeIfPresent(Double.self, forKey: .createdAt)
        createdAt = Date(timeIntervalSince1970: createdUNIXStamp ?? 0.0)
        var lastMeasurementUNIXStamp = try values.decodeIfPresent(Double.self, forKey: .lastTempTime)
        lastTempTime = Date(timeIntervalSince1970: (lastMeasurementUNIXStamp ?? 0.0))
    }
}


let testSensor = Sensor(id: 2, device_name: "testSensor", caption: "caption", latitude: 47.28073, longitude: 8.72869, sponsor_id: 0, createdAt: Date(), latestTemp: 20.0, maxTemp: 20.0, minTemp: 0.0, avgTemp: 10.0,lastTempTime: Date())

