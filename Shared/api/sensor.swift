/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import Combine

class SensorViewModel: ObservableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    @Published var sensorArray = [Sensor]() { didSet {didChange.send(()) } }
}

struct Sensor: Codable {
	let id : Int?
	let device_name : String?
	let caption : String?
	let latitude : Double?
	let longitude : Double?
	let sponsor_id : Int?
	let measurement_ids : [Int]?
	let created_at : String?
	let updated_at : String?
	let last_measurement : Measurement?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case device_name = "device_name"
		case caption = "caption"
		case latitude = "latitude"
		case longitude = "longitude"
		case sponsor_id = "sponsor_id"
		case measurement_ids = "measurement_ids"
		case created_at = "created_at"
		case updated_at = "updated_at"
		case last_measurement = "last_measurement"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
		device_name = try values.decodeIfPresent(String.self, forKey: .device_name)
		caption = try values.decodeIfPresent(String.self, forKey: .caption)
		latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
		longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
		sponsor_id = try values.decodeIfPresent(Int.self, forKey: .sponsor_id)
		measurement_ids = try values.decodeIfPresent([Int].self, forKey: .measurement_ids)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		last_measurement = try values.decodeIfPresent(Measurement.self, forKey: .last_measurement)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}

struct Sensors: Codable {
    let sensors: [Sensor]?
    
    enum CodingKeys: String, CodingKey {
        case sensors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sensors = try container.decode([Sensor].self, forKey: .sensors)
    }
}
